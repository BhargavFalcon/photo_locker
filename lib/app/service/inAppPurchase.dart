import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class InAppPurchaseClass {
  static InAppPurchaseClass? _shared;

  InAppPurchaseClass._();
  static InAppPurchaseClass get getInstance =>
      _shared = _shared ?? InAppPurchaseClass._();

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
  final bool _kAutoConsume = Platform.isIOS || true;

  static List<String> _kProductIds = <String>[
    (Platform.isAndroid)
        ? "com.falcon.easyrecipes.removeAds"
        : "com.rohit.photolocker.all"
  ];

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<GooglePlayPurchaseDetails> pastPurchases = <GooglePlayPurchaseDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  initInAppPurchase() async {
    initStoreInfo();
  }

  initListen() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, context: Get.context!);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("error is $error");
      // handle error here.
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList,
      {required BuildContext context}) {
    if (purchaseDetailsList.isEmpty) {
      box.write(ArgumentConstants.isAdRemoved, false);
    }
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Pending");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          hideCircularDialog(context);
          print("${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          hideCircularDialog(context);
          print("${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          box.write(ArgumentConstants.isAdRemoved, true);
          hideCircularDialog(context);
          if (valid) {
            print("Valid $purchaseDetails");
          } else {
            print("Invalid $purchaseDetails");
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume &&
              _kProductIds.any(
                (element) => element == purchaseDetails.productID,
              )) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition
                .consumePurchase(purchaseDetails)
                .then((value) {
              print("Consumed");
            });
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails)
              .then((value) {
            if (purchaseDetails.status == PurchaseStatus.purchased) {
              box.write(ArgumentConstants.isAdRemoved, true);

              Get.back();
            } else if (purchaseDetails.status == PurchaseStatus.restored) {
              print("ReStored");
              hideCircularDialog(context);
            } else {
              hideCircularDialog(context);
            }
          });
        }
      }
    });
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      products = <ProductDetails>[];
      _purchases = <PurchaseDetails>[];
      _notFoundIds = <String>[];
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      // print("Error is ${productDetailResponse.error?.message}");
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      return;
    }
    print("Error message is ${productDetailResponse.error?.message}");
    print("Error code is ${productDetailResponse.error?.code}");
    print("Error details is ${productDetailResponse.error?.details}");
    print("Error source is ${productDetailResponse.error?.source}");
    print("productDetails is ${productDetailResponse.productDetails}");
    print("notFoundIDs is ${productDetailResponse.notFoundIDs}");

    final List<String> consumables = await ConsumableStore.load();
    _isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _consumables = consumables;
    _purchasePending = false;
    _loading = false;

    getPastPurchases();
    // print("Error is ${productDetailResponse.error?.message}");
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  Card buildProductList({required BuildContext context}) {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
        title: Text('[${_notFoundIds.join(", ")}] not found',
            style: TextStyle(color: ThemeData.light().colorScheme.error)),
        /*subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')*/
      ));
    }
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(
      products.map(
        (ProductDetails productDetails) {
          final PurchaseDetails? previousPurchase =
              purchases[productDetails.id];
          return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null && Platform.isIOS
                ? IconButton(
                    onPressed: () => confirmPriceChange(context),
                    icon: const Icon(Icons.upgrade))
                : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text(productDetails.price),
                  ),
          );
        },
      ),
    );

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

//Restore purchases
  Future<void> restorePurchases({bool isFromInit = false}) async {
    await _inAppPurchase.restorePurchases().then(
      (value) {
        print("Restore => true");
        hideCircularDialog(Get.context!);
        if (!isFromInit) {
          showCupertinoDialogBox(
            Get.context!,
            title: "Restore",
            message: "Restore successful",
          );
        }
      },
    ).catchError((error) {
      print("Restore => false");
      hideCircularDialog(Get.context!);
      SKError e = error as SKError;
      showCupertinoDialogBox(
        Get.context!,
        title: "Restore",
        message: "Nothing to restore",
      );
      print(e.userInfo);
      print(e.code);
      print(e.domain);
    });
  }

  void showCupertinoDialogBox(BuildContext context,
      {String title = "", String message = ""}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 13.0,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //Fetch past purchases
  Future<PurchaseDetails?> getPastPurchases() async {
    PurchaseDetails? purchaseDetails;

    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final QueryPurchaseDetailsResponse response =
          await androidAddition.queryPastPurchases();

      List<GooglePlayPurchaseDetails> pastPurchases = response.pastPurchases;

      if (!pastPurchases.isEmpty) {
        purchaseDetails = pastPurchases[pastPurchases.length - 1];
        this.pastPurchases = pastPurchases;
        debugPrint(
            'Past Purchase ====> ${purchaseDetails.productID} -- ${purchaseDetails.status} -- ${purchaseDetails.purchaseID} -- ${purchaseDetails.pendingCompletePurchase}');
      }
    }

    return purchaseDetails;
  }

  //Make purchase
  void makePurchase({
    required String productId,
    PurchaseDetails? oldSubscription,
  }) async {
    try {
      late PurchaseParam purchaseParam;
      ProductDetails productDetails =
          products.firstWhere((e) => e.id == productId);
      if (Platform.isAndroid) {
        if (pastPurchases.any((element) => element.productID == productId)) {
          oldSubscription = pastPurchases
              .firstWhere((element) => element.productID == productId);
        }
        debugPrint('Old Subscription => ${oldSubscription?.productID}');
        purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            changeSubscriptionParam: (oldSubscription != null)
                ? ChangeSubscriptionParam(
                    oldPurchaseDetails:
                        oldSubscription as GooglePlayPurchaseDetails,
                    prorationMode: ProrationMode.immediateWithTimeProration,
                  )
                : null);
      } else {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
        );
      }

      if (Platform.isIOS) {
        var transactions = await SKPaymentQueueWrapper().transactions();
        transactions.forEach((skPaymentTransactionWrapper) {
          SKPaymentQueueWrapper()
              .finishTransaction(skPaymentTransactionWrapper);
        });
      }

      _inAppPurchase
          .buyNonConsumable(purchaseParam: purchaseParam)
          .then((value) {
        debugPrint('Purchase => $value');
        return true;
      }).catchError((error) {
        debugPrint('catchError => $error');
        return true;
      }).onError((error, stackTrace) {
        debugPrint('onError => $error');
        debugPrint('onError => $stackTrace');
        return true;
      });
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        debugPrint("PlatformException => ${e.message!}");
      }
    } catch (e) {
      hideCircularDialog(Get.context!);
      debugPrint("catch => $e");
    }
  }
}

class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future<void>.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        <String>[];
  }

  static Future<void> _doSave(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
