
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:testnura/model/ProdectModel.dart';
import 'package:testnura/ui/Home/DetailsPage.dart';
import 'package:testnura/ui/Home/cart.dart';
import 'package:testnura/webservice/webservice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 8, 8),
        title: Text(
          "E-commerce",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
          actions: [
      IconButton(
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.red,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (ctx) =>CartPage()));
        },
      )]
      ),
      // drawer: DrawerWidgets(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Most Searched products",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child:
                FutureBuilder<List<ProdectModel>?>(
                  future: Webservice().fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        child: StaggeredGridView.countBuilder(
                          itemCount: snapshot.data!.length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          staggeredTileBuilder: (context) => StaggeredTile.fit(1),
                          crossAxisCount: 2,
                          itemBuilder: (ctx, index) {
                            final product = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>  DetailsPage(price: product.price,id:product.id,title:product. title,image: product.image,description:product.description ),
                                    // Pass product details as arguments to the DetailsPage
                                    settings: RouteSettings(
                                      arguments: product,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            minHeight: 100,
                                            maxHeight: 250,
                                          ),
                                          child: Image.network(
                                           product.image,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                product.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Rs.${product.price}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
            )
          ],
        ),
      ),
    );
  }

  String imageurl = "https://fakestoreapi.com/products";
}
