import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/product/models/product.dart';
import 'package:ecommerce_app_with_flutter/data/product/source/product_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/check_stock.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/update_inventory.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<Either> getTopSelling() async {
    var returnedData = await sl<ProductFirebaseService>().getTopSelling();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getNewIn() async {
    var returnedData = await sl<ProductFirebaseService>().getNewIn();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getProductsByCategoryId(String categoryId) async {
    var returnedData = await sl<ProductFirebaseService>()
        .getProductsByCategoryId(categoryId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    var returnedData = await sl<ProductFirebaseService>().getProductsByTitle(
      title,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product) async {
    var returnedData = await sl<ProductFirebaseService>()
        .addOrRemoveFavoriteProduct(product);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return await sl<ProductFirebaseService>().isFavorite(productId);
  }

  @override
  Future<Either> getFavoritesProducts() async {
    var returnedData = await sl<ProductFirebaseService>()
        .getFavoritesProducts();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> checkStock(CheckStockParams params) async {
    return await sl<ProductFirebaseService>().checkStock(params);
  }

  @override
  Future<Either> updateInventory(UpdateInventoryParams params) async {
    return await sl<ProductFirebaseService>().updateInventory(params);
  }
}
