import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerMenuViewModel>();
    return SizedBox(
      height: 50,
      child: viewModel.categories!.isEmpty
          ? const Text('No categories')
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.categories!.length,
              itemBuilder: (context, index) {
                final category = viewModel.categories![index];
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
                              ? Theme.of(context).secondaryHeaderColor
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
