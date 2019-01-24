import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';

class Tiles extends StatelessWidget {
  final Function onTap;

  Tiles({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _TilesViewModel>(
      converter: _TilesViewModel.fromState,
      builder: (context, vm) {
        return GridView.count(
          shrinkWrap: true,
          primary: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: vm.categories
              .map((category) => ItemTile(onTap, category))
              .toList(),
        );
      },
    );
  }
}

class _TilesViewModel {
  final List<String> categories;

  _TilesViewModel({@required this.categories});

  static _TilesViewModel fromState(Store<AppState> store) {
    return _TilesViewModel(categories: store.state.categories);
  }
}

class ItemTile extends StatelessWidget {
  final Function onTap;
  final String category;

  ItemTile(this.onTap, this.category);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ItemTileViewModel>(
      converter: _ItemTileViewModel.fromState,
      builder: (context, vm) {
        return Center(
          child: InkResponse(
            onTap: () {
              onTap(category);
              vm.handleClick(category);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(vm.selected == category
                    ? Icons.shopping_basket
                    : Icons.euro_symbol),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ItemTileViewModel {
  final Function(String) handleClick;
  final String selected;

  _ItemTileViewModel({@required this.handleClick, @required this.selected});

  static _ItemTileViewModel fromState(Store<AppState> store) {
    return _ItemTileViewModel(
      handleClick: (category) => store.dispatch(SelectCategory(category)),
      selected: store.state.chosenCategory,
    );
  }
}
