import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/product/models/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/check_stock.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/update_inventory.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProductFirebaseService {
  Future<Either> getTopSelling();
  Future<Either> getNewIn();
  Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);

  Future<bool> isFavorite(String productId);
  Future<Either> getFavoritesProducts();
  Future<Either> checkStock(CheckStockParams params);
  Future<Either> updateInventory(UpdateInventoryParams params);
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {
  @override
  Future<Either> getTopSelling() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Products')
          .where('salesNumber', isGreaterThanOrEqualTo: 20)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getNewIn() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Products')
          .where('createdDate', isGreaterThanOrEqualTo: DateTime(2025, 08, 10))
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getProductsByCategoryId(String categoryId) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Products')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Products')
          .where('title', isGreaterThanOrEqualTo: title)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var products = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .collection('Favorites')
          .where('productId', isEqualTo: product.productId)
          .get();

      if (products.docs.isNotEmpty) {
        await products.docs.first.reference.delete();
        return const Right(false);
      } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection('Favorites')
            .add(product.fromEntity().toMap());
        return const Right(true);
      }
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var products = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .collection('Favorites')
          .where('productId', isEqualTo: productId)
          .get();

      if (products.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getFavoritesProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .collection('Favorites')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> checkStock(CheckStockParams params) async {
    try {
      var productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .where('productId', isEqualTo: params.productId)
          .get();

      if (productDoc.docs.isEmpty) {
        return const Left('Product not found');
      }

      var productData = productDoc.docs.first.data();
      var inventory = Map<String, int>.from(productData['inventory'] ?? {});
      String variantKey = '${params.color}-${params.size}';
      int availableStock = inventory[variantKey] ?? 0;

      if (availableStock >= params.requestedQuantity) {
        return Right({
          'available': true,
          'stock': availableStock,
          'message': 'In stock',
        });
      } else if (availableStock > 0) {
        return Right({
          'available': false,
          'stock': availableStock,
          'message': 'Only $availableStock items available',
        });
      } else {
        return Right({
          'available': false,
          'stock': 0,
          'message': 'Out of stock',
        });
      }
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateInventory(UpdateInventoryParams params) async {
    try {
      // Use a batch to ensure all updates succeed or fail together
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var product in params.products) {
        // Get the product document
        var productQuery = await FirebaseFirestore.instance
            .collection('Products')
            .where('productId', isEqualTo: product.productId)
            .get();

        if (productQuery.docs.isNotEmpty) {
          var productDoc = productQuery.docs.first;
          var productData = productDoc.data();
          var inventory = Map<String, int>.from(productData['inventory'] ?? {});

          String variantKey = '${product.productColor}-${product.productSize}';
          int currentStock = inventory[variantKey] ?? 0;
          int newStock = currentStock - product.productQuantity;

          // Ensure stock doesn't go negative
          if (newStock < 0) {
            return Left(
              'Insufficient stock for ${product.productTitle} (${product.productColor}, ${product.productSize})',
            );
          }

          // Update inventory
          inventory[variantKey] = newStock;

          // Calculate new total stock
          int totalStock = inventory.values.fold(
            0,
            (total, stock) => total + stock,
          );

          // Add to batch
          batch.update(productDoc.reference, {
            'inventory': inventory,
            'totalStock': totalStock,
          });
        }
      }

      // Commit all updates
      await batch.commit();
      return const Right('Inventory updated successfully');
    } catch (e) {
      return const Left('Failed to update inventory');
    }
  }
}
