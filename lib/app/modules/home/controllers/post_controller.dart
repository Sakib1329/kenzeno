// lib/app/modules/community/controllers/forum_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../constants/appconstants.dart';
import '../models/post_modeel.dart';

import '../../../res/colors/colors.dart';

class ForumController extends GetxController {
  final box = GetStorage();

  var isLoading = true.obs;
  var posts = <ForumPost>[].obs;
  var comments = <ForumComment>[].obs;
  var isPosting = false.obs;
  var isLoadingComments = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts({bool showLoading = true}) async {
    if (showLoading) isLoading(true);
    try {
      final token = box.read("loginToken");
      if (token == null) throw Exception("Not logged in");

      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl}/community/forum-posts/"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> results = jsonResponse['results'] ?? [];
        final fetched = results
            .map((e) => ForumPost.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        posts.assignAll(fetched);
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load posts",
          backgroundColor: AppColor.redDC2626, colorText: Colors.white);
    } finally {
      if (showLoading) isLoading(false);
    }
  }

  Future<void> fetchComments(int postId) async {
    final token = box.read("loginToken");
    if (token == null) return;

    try {
      isLoadingComments.value = true;
      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl}/community/forum-comments/$postId/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> results = json['results'] ?? [];

        comments.assignAll(
          results
              .map((e) => ForumComment.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
        );
      }
    } catch (e) {
      print("Fetch comments error: $e");
      comments.clear();
      Get.snackbar("Error", "Failed to load comments", backgroundColor: AppColor.redDC2626);
    } finally {
      isLoadingComments.value = false;
    }
  }

  // LIKE / UNLIKE POST (Optimistic + Instant UI)
  Future<void> toggleLike(int id) async {
    final token = box.read("loginToken");
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/community/forum-post-like/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"post": id}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
refreshPosts();

      } else {

        Get.snackbar("Failed", "Could not update like", backgroundColor: AppColor.redDC2626);
      }
    } catch (e) {

      Get.snackbar("Error", "Check your connection", backgroundColor: AppColor.redDC2626);
    }
  }

  Future<bool> createComment({required int postId, required String content}) async {
    final token = box.read("loginToken");
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/community/forum-comment-create/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"post": postId, "content": content.trim()}),
      );

      if (response.statusCode == 201) {
        // Update comment count
        final postIndex = posts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          posts[postIndex] = posts[postIndex].copyWith(comments: posts[postIndex].comments + 1);
          posts.refresh();
        }
        await fetchComments(postId);
        return true;
      }
    } catch (e) {
      print("Create comment error: $e");
    }
    return false;
  }

  Future<bool> updateForumPost({required int postId, required String newContent}) async {
    final token = box.read("loginToken");
    if (token == null) return false;

    try {
      isPosting.value = true;
      final response = await http.patch(
        Uri.parse("${AppConstants.baseUrl}/community/forum-posts/$postId/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"content": newContent.trim()}),
      );

      if (response.statusCode == 200) {
        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          posts[index] = posts[index].copyWith(content: newContent.trim());
          posts.refresh();
        }
        Get.snackbar("Success", "Post updated", backgroundColor: AppColor.green22C55E, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      print("Update post error: $e");
    } finally {
      isPosting.value = false;
    }
    return false;
  }

  Future<bool> deleteForumPost({required int postId}) async {
    final token = box.read("loginToken");
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse("${AppConstants.baseUrl}/community/forum-posts/$postId/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        posts.removeWhere((p) => p.id == postId);
        Get.snackbar("Deleted", "Post removed", backgroundColor: AppColor.green22C55E, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete post", backgroundColor: AppColor.redDC2626);
    }
    return false;
  }

  Future<bool> updateComment({required int commentId, required String newContent}) async {
    final token = box.read("loginToken");
    if (token == null) return false;

    try {
      isLoadingComments.value = true;
      final response = await http.patch(
        Uri.parse("${AppConstants.baseUrl}/community/forum-comment/$commentId/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"content": newContent.trim()}),
      );

      if (response.statusCode == 200) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments[index] = comments[index].copyWith(content: newContent.trim());
          comments.refresh();
        }
        Get.snackbar("Updated", "Comment edited", backgroundColor: AppColor.green22C55E, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      print("Update comment error: $e");
    } finally {
      isLoadingComments.value = false;
    }
    return false;
  }

  Future<bool> deleteComment({required int commentId, required int postId}) async {
    final token = box.read("loginToken");
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse("${AppConstants.baseUrl}/community/forum-comment/$commentId/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        comments.removeWhere((c) => c.id == commentId);
        comments.refresh();

        final postIndex = posts.indexWhere((p) => p.id == postId);
        if (postIndex != -1 && posts[postIndex].comments > 0) {
          posts[postIndex] = posts[postIndex].copyWith(comments: posts[postIndex].comments - 1);
          posts.refresh();
        }

        Get.snackbar("Deleted", "Comment removed", backgroundColor: AppColor.green22C55E, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      print("Delete comment error: $e");
    }
    return false;
  }

  Future<bool> createForumPost({required String content}) async {
    final token = box.read("loginToken");
    if (token == null) {
      Get.snackbar("Error", "Login required", backgroundColor: AppColor.redDC2626);
      return false;
    }

    try {
      isPosting.value = true;
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/community/forum-posts/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"content": content.trim()}),
      );

      if (response.statusCode == 201) {
        final newPost = ForumPost.fromJson(jsonDecode(response.body));
        posts.insert(0, newPost);
        Get.snackbar("Success", "Posted!", backgroundColor: AppColor.green22C55E, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      print("Create post error: $e");
      Get.snackbar("Error", "Failed to post", backgroundColor: AppColor.redDC2626);
    } finally {
      isPosting.value = false;
    }
    return false;
  }

  Future<void> refreshPosts() => fetchPosts(showLoading: false);
}