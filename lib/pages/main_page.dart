import 'package:flutter/material.dart';

import '../datamanager.dart';
import '../datamodel.dart';

class MenuPage extends StatelessWidget {
  final DataManager dataManager;

  const MenuPage({Key? key, required this.dataManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Category>>(
        future: dataManager.getMenu(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Extracting category list from the snapshot
            List<Category> categories = snapshot.data!;

            return CategoryListView(
              categories: categories,
              dataManager: dataManager,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class CategoryListView extends StatefulWidget {
  final List<Category> categories;
  final DataManager dataManager;

  const CategoryListView({
    Key? key,
    required this.categories,
    required this.dataManager,
  }) : super(key: key);

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    // Set the selectedCategory to the first category by default
    selectedCategory = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display buttons for each category at the top
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.categories.map((category) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Text(category.name),
                ),
              );
            }).toList(),
          ),
        ),
        // Display products for the selected category
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: selectedCategory.products.length,
            itemBuilder: (context, index) {
              return MenuItem(
                product: selectedCategory.products[index],
                onAdd: (p) => widget.dataManager.cartAdd(p,context),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final Product product;
  final Function onAdd;

  const MenuItem({
    Key? key,
    required this.product,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Image.network(product.image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("\$${product.price.toStringAsFixed(2)}"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onAdd(product);
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
