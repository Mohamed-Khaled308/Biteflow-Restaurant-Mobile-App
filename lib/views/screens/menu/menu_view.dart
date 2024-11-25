import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/views/theme/theme_data.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../view-model/menu_view_model.dart';
import '../../widgets/menu/menu_item_grid.dart';
import '../../widgets/menu/menu_card.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late ScrollController _scrollController;
  double _placeholderOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // Adjust the placeholder opacity based on scroll offset
          _placeholderOpacity = (_scrollController.offset < 300)
              ? 1 - (_scrollController.offset / 300)
              : 0;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = getIt<MenuViewModel>();
    //final screenHeight = MediaQuery.of(context).size.height;
    //print('Screen height: $screenHeight');

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Placeholder Section
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _placeholderOpacity,
                  child: Container(
                    width: double.infinity, // Full screen width
                    height:
                        300, // Fixed height to match the placeholder's height
                    // color: ThemeConstants.primaryMaterialColor[300],
                    child: Image.asset(
                      'assets/images/BiteFlowNew.png',
                      fit: BoxFit
                          .cover, // Scale and crop the image to fully fill the container
                    ),
                  ),
                ),
              ),
              // Fixed Categories
              SliverPersistentHeader(
                pinned: true,
                delegate: CategoriesHeaderDelegate(
                  categories: _viewModel.categories,
                  selectedCategoryId: _viewModel.selectedCategoryId ?? '',
                  onCategorySelected: (id) => _viewModel.selectCategory(id),
                  theme: Theme.of(context),
                ),
              ),

              SliverLayoutBuilder(
                builder: (BuildContext context, SliverConstraints constraints) {
                  final totalFilteredItemCount = _viewModel.filteredItems.length;
                  // print('FilterdItems: $totalFilteredItemCount');
                  if (totalFilteredItemCount < 3) {
                    // Few items case: Use SliverFillRemaining to stretch
                    return // Scrollable Items
                        SliverFillRemaining(
                      hasScrollBody: true,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _viewModel.filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _viewModel.filteredItems[index];
                                return MenuItemGrid(
                                  imageUrl: item.imageUrl,
                                  title: item.title,
                                  price: item.price,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return MenuCard(
                                          imageUrl: item.imageUrl,
                                          title: item.title,
                                          description: item.description,
                                          price: item.price,
                                          rating: item.rating,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Many items case: Use SliverList for scrollable content
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final _item = _viewModel.filteredItems[index];
                          return MenuItemGrid(
                            imageUrl: _item.imageUrl,
                            title: _item.title,
                            price: _item.price,
                            onTap: () {
                              _viewModel.selectMenuItem(_item);
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return MenuCard(
                                    imageUrl: _item.imageUrl,
                                    title: _item.title,
                                    description: _item.description,
                                    price: _item.price,
                                    rating: _item.rating,
                                  );
                                },
                              );
                            },
                          );
                        },
                        childCount: _viewModel.filteredItems.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoriesHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<Category> categories;
  final String selectedCategoryId;
  final Function(String) onCategorySelected;
  final ThemeData theme;

  CategoriesHeaderDelegate({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.theme,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedCategoryId == category.id
                    ? theme.primaryColor
                    : theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category.title,
                  style: TextStyle(
                    color: selectedCategoryId == category.id
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
