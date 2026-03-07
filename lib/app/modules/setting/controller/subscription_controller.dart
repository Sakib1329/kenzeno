// lib/controllers/subscription_controller.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  /// Observables for UI
  final isLoading = false.obs;
  final isSubscribed = false.obs;
  final activePlan = 'free'.obs; // 'free', 'monthly', 'yearly', 'trial'

  Offerings? currentOfferings;

  @override
  void onInit() {
    super.onInit();
    _initRevenueCat();
  }

  Future<void> _initRevenueCat() async {
    try {
      final appleKey = dotenv.env['REVENUECAT_APPLE_PUBLIC_KEY'];

      if (appleKey == null || appleKey.isEmpty) {
        throw Exception('RevenueCat Apple key missing in .env');
      }

      await Purchases.configure(
        PurchasesConfiguration(appleKey)
          ..appUserID = null, // anonymous for now; change to user ID after login
      );

      Purchases.addCustomerInfoUpdateListener(_handleCustomerUpdate);

      await _refreshCustomerInfo();
      await _fetchOfferings();
    } catch (e) {
      print("RevenueCat init failed: $e");
      Get.snackbar('Error', 'Failed to load subscription system');
    }
  }

  Future<void> _refreshCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateEntitlement(customerInfo);
    } catch (e) {
      print("Refresh customer info error: $e");
    }
  }

  void _handleCustomerUpdate(CustomerInfo info) {
    _updateEntitlement(info);

    if (isSubscribed.value) {

    }
  }

  Future<void> _fetchOfferings() async {
    try {
      isLoading.value = true;
      currentOfferings = await Purchases.getOfferings();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Fetch offerings error: $e");
      Get.snackbar('Error', 'Could not load subscription plans');
    }
  }

  /// Call this when user wants to refresh plans (e.g. pull-to-refresh)
  Future<void> refreshOfferings() => _fetchOfferings();

  /// Purchase selected package
  /// Purchase a package (Monthly / Yearly)
  /// Purchase a package (Monthly / Yearly)
  Future<void> purchasePackage(Package package) async {
    try {
      isLoading.value = true;

      // Correct named factory constructor (fixes previous constructor error)
      final purchaseParams = PurchaseParams.package(package);

      // Modern return type: PurchaseResult (not CustomerInfo directly)
      final PurchaseResult purchaseResult = await Purchases.purchase(purchaseParams);

      // Extract the updated CustomerInfo from the result
      final CustomerInfo customerInfo = purchaseResult.customerInfo;

      // Now update your state
      _updateEntitlement(customerInfo);

      isLoading.value = false;

      Get.snackbar('Success', 'Subscription activated!');

      // Optional: Navigate to home after success
      // Get.offAllNamed('/navbar');

    } on PurchasesError catch (e) {
      isLoading.value = false;
      print("Purchase error: ${e.code} - ${e.message}");
      Get.snackbar(
        'Purchase Failed',
        e.message ?? 'Please try again or check your payment method.',
      );
    } catch (e) {
      isLoading.value = false;
      print("Unexpected purchase error: $e");
      Get.snackbar('Error', 'Something went wrong during purchase');
    }
  }

  /// Restore purchases button
  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      final customerInfo = await Purchases.restorePurchases();
      _updateEntitlement(customerInfo);
      isLoading.value = false;
      if (isSubscribed.value) {
        Get.snackbar('Success', 'Purchases restored!');
      } else {
        Get.snackbar('Info', 'No active subscription found');
      }
    } catch (e) {
      isLoading.value = false;
      print("Restore error: $e");
      Get.snackbar('Error', 'Restore failed');
    }
  }

  /// Private: update UI state from customer info
  void _updateEntitlement(CustomerInfo info) {
    final entitlement = info.entitlements.all['pro']; // ← your entitlement ID

    isSubscribed.value = entitlement?.isActive ?? false;

    if (isSubscribed.value) {
      if (entitlement!.periodType == PeriodType.trial) {
        activePlan.value = 'trial';
      } else {
        // Detect monthly/yearly from product ID (adjust to your IDs)
        final pid = entitlement.productIdentifier.toLowerCase();
        if (pid.contains('year') || pid.contains('annual')) {
          activePlan.value = 'yearly';
        } else {
          activePlan.value = 'monthly';
        }
      }
    } else {
      activePlan.value = 'free';
    }
  }

  /// Status text for UI (e.g. "Free Trial • Ends 2026-03-06")
  String getStatusText() {
    if (!isSubscribed.value) {
      return 'Start your 7-day free trial';
    }

    if (activePlan.value == 'trial') {
      return 'Free Trial active';
    }

    return 'Subscribed (${activePlan.value.capitalize})';
  }

  @override
  void onClose() {
    // Optional: remove listener if needed
    super.onClose();
  }
}