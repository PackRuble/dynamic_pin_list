import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const FastApp());
}

class FastApp extends StatelessWidget {
  const FastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      scrollBehavior: const CupertinoScrollBehavior(),
      home: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic Pin&Unpin list'),
          ),
          body: const PinnedList(),
        ),
      ),
    );
  }
}

class PinnedList extends HookWidget {
  const PinnedList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(PinnedList);

    // Set the minimum value to see a smooth animation
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 1);

    const pinnedItemIndex = 23;

    final products = List.generate(
        100,
        (index) => ProductItem(
              'Product $index',
              index == pinnedItemIndex ? true : false,
            ));

    final productsBefore = products.sublist(0, pinnedItemIndex);
    final productsAfter = products.sublist(pinnedItemIndex + 1);

    final selectedProduct = products[pinnedItemIndex];

    final animation = useAnimationController(initialValue: 1);

    final selectedItemWidget = VisibilityDetector(
      key: ValueKey(selectedProduct.name),
      onVisibilityChanged: (VisibilityInfo info) {
        animation.value = 1 - info.visibleFraction;
      },
      child: Tile(
        product: selectedProduct,
        color: Colors.red,
      ),
    );

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              getSliverList(productsBefore),
              SliverPinnedHeader(child: selectedItemWidget),
              getSliverList(productsAfter),
            ],
          ),
        ),
        BottomTile(
          product: selectedProduct,
          animation: animation,
        ),
      ],
    );
  }

  SliverList getSliverList(List<ProductItem> items) => SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (context, index) {
            return Tile(product: items[index]);
          },
        ),
      );
}

class BottomTile extends StatelessWidget {
  const BottomTile({
    Key? key,
    required this.product,
    required this.animation,
  }) : super(key: key);

  final ProductItem product;
  final AnimationController animation;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            heightFactor: animation.value,
            child: child,
          );
        },
        child: Tile(
          product: product,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.product,
    this.color,
  }) : super(key: key);

  final ProductItem product;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {},
          title: Text(product.name),
          selectedTileColor: color,
          leading: Icon(
            Icons.star,
            color: product.isPin ? Colors.yellow : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(),
          ),
          selected: product.isPin,
        ),
      ),
    );
  }
}

class ProductItem {
  ProductItem(this.name, this.isPin);
  final String name;
  final bool isPin;
}
