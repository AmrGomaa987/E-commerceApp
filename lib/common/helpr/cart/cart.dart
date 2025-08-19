
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';

class CartHelper {

  static double calculateCartSubtotal(List<ProductOrderedEntity> products) {
    double subtotalPrice = 0;
    for(var item in products) {
      subtotalPrice = subtotalPrice + item.totalPrice;
    }
    return subtotalPrice;
  }
}