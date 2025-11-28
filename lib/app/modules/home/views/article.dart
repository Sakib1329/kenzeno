import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/controllers/homecontroller.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../setting/widgets/trainnigstep.dart';
import 'articledetails.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Text(
              "No articles available",
              style: AppTextStyles.poppinsRegular.copyWith(
                color: AppColor.white,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles[index];

            return TrainingCardWidget(
              title: article.title,
              subtitle: article.category,
              imagePath: article.mediaUrl ?? ImageAssets.img_3,
              type: 'article',
              duration: '0 min',
              calories: '0 kcal',
              exercises: '0 exercises',
              isVideo: false,
              onTap: () {
                Get.to(
                      () => const ArticleDetailPage(),
                  arguments: article.id,  // Only ID needed!
                  transition: Transition.rightToLeft,
                );
              },
            );
          },
        );
      }),
    );
  }
}
