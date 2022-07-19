import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as ord;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) async {

  //   // _isLoading = true;
  //   // Provider.of<ord.Orders>(context, listen: false)
  //   //     .fetchAndSetOrders()
  //   //     .then((_) => setState(() {
  //   //           _isLoading = false;
  //   //         }));

  //   super.initState();
  // }
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<ord.Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('builder orders');
    // final orderData = Provider.of<ord.Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(
                    child: Text("An error occurred!"),
                  );
                } else {
                  return Consumer<ord.Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                      itemBuilder: (_, i) => OrderItem(
                        (orderData.orders[i]),
                      ),
                      itemCount: orderData.orders.length,
                    ),
                  );
                }
              }
            },
            future: _ordersFuture));
  }
}
