import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/check_stock.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/update_inventory.dart';

abstract class ProductRepository {
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
