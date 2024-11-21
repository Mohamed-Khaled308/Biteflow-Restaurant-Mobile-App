import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view-model/menu_view_model.dart';
import '../../widgets/menu/menu_item_grid.dart';
import '../../widgets/menu/menu_card.dart';
import '../../theme/app_theme.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MenuViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Menu Card
          viewModel.selectedItem == null
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select an item to see details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : MenuCard(
                  imageUrl: viewModel.selectedItem!.imageUrl,
                  title: viewModel.selectedItem!.title,
                  description: viewModel.selectedItem!.description,
                  price: viewModel.selectedItem!.price,
                  rating: viewModel.selectedItem!.rating,
                ),
          const SizedBox(height: 10),

          // Horizontal Category Slider
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final category = viewModel.categories[index];
                return GestureDetector(
                  onTap: () => viewModel.selectCategory(category.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: viewModel.selectedCategoryId == category.id
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          color: viewModel.selectedCategoryId == category.id
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Grid of Menu Items
          Expanded(
            child: MenuItemGrid(
              items: viewModel.filteredItems,
              onTap: viewModel.selectMenuItem,
            ),
          ),
        ],
      ),
    );
  }
}
