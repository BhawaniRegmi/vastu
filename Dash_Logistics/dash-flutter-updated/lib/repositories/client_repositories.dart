import 'package:http/http.dart' as http;
import 'dart:convert';

// Import your model and response classes
import 'models/order_model.dart';
import 'models/order_response.dart';

class OrderRepository {
  final String baseUrl;
  final http.Client client;

  OrderRepository({required this.baseUrl, http.Client? httpClient})
      : client = httpClient ?? http.Client();

  // Example: Fetch a single order by ID
  Future<OrderResponse> getOrder(String orderId) async {
    final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OrderResponse.fromJson(jsonResponse);
      } else {
        // Handle error based on status code
        return OrderResponse(success: false, message: 'Failed to fetch order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return OrderResponse(success: false, message: 'Error during API call: $e');
    }
  }

  // Example: Fetch all orders for a user
  Future<OrderListResponse> getUserOrders(String userId) async {
    final Uri uri = Uri.parse('$baseUrl/users/$userId/orders');
    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OrderListResponse.fromJson(jsonResponse);
      } else {
        return OrderListResponse(success: false, message: 'Failed to fetch user orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return OrderListResponse(success: false, message: 'Error during API call: $e');
    }
  }

  // Example: Create a new order
  Future<OrderResponse> createOrder(Order order) async {
    final Uri uri = Uri.parse('$baseUrl/orders');
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OrderResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        // Handle validation errors or bad requests
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OrderResponse(success: false, message: jsonResponse['message'] ?? 'Invalid order data');
      } else {
        return OrderResponse(success: false, message: 'Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return OrderResponse(success: false, message: 'Error during API call: $e');
    }
  }

  // Example: Update an existing order
  Future<OrderResponse> updateOrder(String orderId, Order updatedOrder) async {
    final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
    try {
      final response = await client.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedOrder.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OrderResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        return OrderResponse(success: false, message: 'Order not found');
      } else {
        return OrderResponse(success: false, message: 'Failed to update order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return OrderResponse(success: false, message: 'Error during API call: $e');
    }
  }

  // Example: Delete an order
  Future<OrderResponse> deleteOrder(String orderId) async {
    final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
    try {
      final response = await client.delete(uri);

      if (response.statusCode == 200) {
        return OrderResponse(success: true, message: 'Order deleted successfully');
      } else if (response.statusCode == 404) {
        return OrderResponse(success: false, message: 'Order not found');
      } else {
        return OrderResponse(success: false, message: 'Failed to delete order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return OrderResponse(success: false, message: 'Error during API call: $e');
    }
  }

  // Dispose the client when it's no longer needed
  void dispose() {
    client.close();
  }
}