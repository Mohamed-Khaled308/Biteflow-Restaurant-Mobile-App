import 'package:biteflow/locator.dart';
// import 'package:biteflow/models/cart.dart';
import 'package:biteflow/models/category.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/menu_view_model.dart';
import 'package:biteflow/views/widgets/cart/cart_icon.dart';
import 'package:biteflow/views/screens/feedback/feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../widgets/menu/menu_item_grid.dart';
import '../../widgets/menu/menu_card.dart';


class MenuScreen extends StatefulWidget {
  final String restaurantId;
  const MenuScreen({super.key, required this.restaurantId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<MenuViewModel>();
      viewModel.restaurantId = widget.restaurantId;
      await viewModel.loadRestaurantData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItemList(MenuViewModel viewModel, CartViewModel cartViewModel) {
    final totalFilteredItemCount = viewModel.filteredItems.length;

    if (totalFilteredItemCount < 3) {
      // Few items: use a ListView inside SliverFillRemaining
      return SliverFillRemaining(
        hasScrollBody: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalFilteredItemCount,
                  itemBuilder: (context, index) {
                    final item = viewModel.filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MenuItemGrid(
                          imageUrl: item.imageUrl,
                          title: item.title,
                          price: item.price,
                          discountPercentage: item.discountPercentage,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return ChangeNotifierProvider.value(
                                  value: getIt<CartViewModel>(),
                                  child: SingleChildScrollView(
                                    child: MenuCard(
                                      imageUrl: item.imageUrl,
                                      title: item.title,
                                      description: item.description,
                                      price: item.price,
                                      rating: item.rating,
                                      categoryId: item.categoryId,
                                      restaurantId: widget.restaurantId,
                                      discountPercentage: item.discountPercentage,

                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Many items: use SliverList
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = viewModel.filteredItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MenuItemGrid(
                  imageUrl: item.imageUrl,
                  title: item.title,
                  price: item.price,
                  discountPercentage: item.discountPercentage,
                  onTap: () {
                    viewModel.selectedItem = item;
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
                          categoryId: item.categoryId,
                          restaurantId: widget.restaurantId,
                          discountPercentage: item.discountPercentage,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
          childCount: totalFilteredItemCount,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();
    final cartViewModel = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              getIt<NavigationService>().navigateTo(
                FeedbackView(restaurantId: widget.restaurantId),
              );
            },
            icon: const Icon(Icons.feedback),
          ),
          Visibility(
            visible: !cartViewModel.isCartEmpty,
            child: const CartIcon(),
          ),
          // IconButton(
          //   onPressed: () {
          //     getIt<NavigationService>().navigateTo(const CartView());
          //   },
          //   icon: const Icon(Icons.shopping_cart_sharp),
          // ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Placeholder Section with a gradient overlay
          SliverToBoxAdapter(
            child: Consumer<MenuViewModel>(
              builder: (context, viewModel, child) {
                final imageUrl = viewModel.restaurantImageUrl;

                return Hero(
                  tag: widget.restaurantId,
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _placeholderOpacity,
                        child: SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Fixed Categories
          SliverPersistentHeader(
            pinned: true,
            delegate: CategoriesHeaderDelegate(
              categories: viewModel.categories ?? [],
              selectedCategoryId: viewModel.selectedCategoryId ?? '',
              onCategorySelected: (id) {
                viewModel.selectedCategoryId = id;
              },
              theme: Theme.of(context),
            ),
          ),

          // Items
          SliverLayoutBuilder(
            builder: (BuildContext context, SliverConstraints constraints) {
              return _buildItemList(viewModel, cartViewModel);
            },
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: theme.scaffoldBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;
          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor
                    : theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  category.title,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).secondaryHeaderColor
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
