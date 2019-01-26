import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  final Function(String) onTap;
  final List<String> categories;
  final String selected;

  CategoryGrid({
    @required this.onTap,
    @required this.categories,
    @required this.selected,
  });

  @override
  State<StatefulWidget> createState() {
    return _CategoryGridState(onTap, categories, selected);
  }
}

class _CategoryGridState extends State<CategoryGrid> {
  final Function(String) onTap;
  final List<String> categories;
  final String selected;

  List<Widget> categoryTiles;

  _CategoryGridState(this.onTap, this.categories, this.selected);

  void _handleTap(String selected) {
    onTap(selected);
    setState(() {
      categoryTiles = categories
          .map((category) => new CategoryTile(
                handleTap: _handleTap,
                category: category,
                selected: selected == category,
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    categoryTiles = categories
        .map((category) => new CategoryTile(
              key: ValueKey(category), //TODO: should be IDs, might repeat?
              handleTap: _handleTap,
              category: category,
              selected: selected == category,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      children: categoryTiles,
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Function(String) handleTap;
  final String category;
  final bool selected;

  CategoryTile({
    Key key,
    @required this.handleTap,
    @required this.category,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => handleTap(category),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? Color.fromRGBO(211, 211, 211, 0.7)
                      : Colors.white,
                ),
                child: Icon(Icons.add_shopping_cart),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
