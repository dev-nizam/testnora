import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testnura/provider/cartProvider.dart';
import 'package:testnura/ui/Home/Home.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {
              // Implement delete functionality
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (ctx, index) {
          var cartItem = cartItems[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(cartItem.image),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              cartItem.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cartItem.price.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cartProvider.updateItemQuantity(cartItem, cartItem.qty - 1);
                                        },
                                        icon: Icon(
                                          Icons.minimize_rounded,
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        cartItem.qty.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cartProvider.updateItemQuantity(cartItem, cartItem.qty + 1);
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${cartProvider.calculateTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                // Implement order now functionality
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Order Now",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
