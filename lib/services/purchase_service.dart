import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'local_storage_service.dart';

class PurchaseService {
  static final InAppPurchase _iap = InAppPurchase.instance;

  static const String proMonthlyId = 'heic_pro_monthly';
  static const String proYearlyId = 'heic_pro_yearly';
  static const String proLifetimeId = 'heic_pro_lifetime';

  static final Set<String> _productIds = {
    proMonthlyId,
    proYearlyId,
    proLifetimeId,
  };

  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static List<ProductDetails> _products = [];

  static Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => print('Purchase error: $error'),
    );
  }

  static Future<List<ProductDetails>> loadProducts() async {
    final available = await _iap.isAvailable();
    if (!available) return [];

    final response = await _iap.queryProductDetails(_productIds);
    _products = response.productDetails;
    return _products;
  }

  static Future<bool> purchaseProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('Purchase failed: $e');
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      print('Restore failed: $e');
    }
  }

  static void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _verifyAndDeliverProduct(purchaseDetails);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }

  static Future<void> _verifyAndDeliverProduct(
      PurchaseDetails purchaseDetails) async {
    if (_productIds.contains(purchaseDetails.productID)) {
      await LocalStorageService.setProStatus(true);
    }
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static List<ProductDetails> get products => _products;
}
