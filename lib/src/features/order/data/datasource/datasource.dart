class OrderDataSource{
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrder(String id);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<OrderModel> deleteOrder(String id);
}