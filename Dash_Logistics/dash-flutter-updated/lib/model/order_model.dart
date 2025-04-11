// order_model.dart

class Order {
  final String orderId;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String orderStatus;
  final String? shippingAddress;
  final String? paymentMethod;

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.orderStatus,
    this.shippingAddress,
    this.paymentMethod,
  });

  // Factory method to create an Order object from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((itemJson) => OrderItem.fromJson(itemJson as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      orderStatus: json['orderStatus'] as String,
      shippingAddress: json['shippingAddress'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  // Method to convert the Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'orderStatus': orderStatus,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  // Factory method to create an OrderItem object from a JSON map
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Method to convert the OrderItem object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

// order_response.dart

class OrderResponse {
  final bool success;
  final String? message;
  final Order? data;

  OrderResponse({
    required this.success,
    this.message,
    this.data,
  });

  // Factory method to create an OrderResponse object from a JSON map
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null ? Order.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class OrderListResponse {
  final bool success;
  final String? message;
  final List<Order>? data;

  OrderListResponse({
    required this.success,
    this.message,
    this.data,
  });

  // Factory method to create an OrderListResponse object from a JSON map
  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((orderJson) => Order.fromJson(orderJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderErrorResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  OrderErrorResponse({
    required this.success,
    required this.message,
    this.errors,
  });

  // Factory method to create an OrderErrorResponse object from a JSON map
  factory OrderErrorResponse.fromJson(Map<String, dynamic> json) {
    return OrderErrorResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}