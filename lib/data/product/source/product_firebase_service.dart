import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ProductFirebaseService {
  Future<Either> getTopSelling();
  // Future<Either> getNewIn();
  // Future<Either> getProductsByCategoryId(String categoryId);
  // Future<Either> getProductsByTitle(String title);
  // Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);
  // Future<bool> isFavorite(String productId);
  // Future<Either> getFavoritesProducts();
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {
  @override
  Future < Either > getTopSelling() async {
    try {
      var returnedData = await FirebaseFirestore.instance.collection(
        'Products'
      ).where(
        'salesNumber',
        isGreaterThanOrEqualTo: 20
      ).get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left(
        'Please try again'
      );
    }
  }

}
