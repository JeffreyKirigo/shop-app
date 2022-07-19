import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
// import 'package:shop_app/providers/product.dart';
// import 'package:shop_app/providers/product_provider.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/product_provider.dart';

enum MenuOption { all, favorites }

class ProductOvervieScreen extends StatefulWidget {
  const ProductOvervieScreen({Key? key}) : super(key: key);

  @override
  State<ProductOvervieScreen> createState() => _ProductOvervieScreenState();
}

class _ProductOvervieScreenState extends State<ProductOvervieScreen> {
  var _showFavorites = false;
  var _isLoading = false;
  var _isInit = true;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK
    // Future.delayed(Duration.zero)
    //     .then((_) => Provider.of<Products>(context).fetchAndSetProducts());

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (MenuOption selectedValue) {
              setState(() {
                if (selectedValue == MenuOption.favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text('Favorites only'),
                value: MenuOption.favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: MenuOption.all,
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cartData.itemCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavorites),
    );
  }
}
