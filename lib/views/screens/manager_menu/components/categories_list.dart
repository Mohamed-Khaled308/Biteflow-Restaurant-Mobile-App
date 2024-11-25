import 'package:flutter/material.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/view-model/manager_menu_view_model.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

  final ManagerMenuViewModel _viewModel =  getIt<ManagerMenuViewModel>();


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = _viewModel.categories[index];
              return GestureDetector(
                onTap: () => _viewModel.selectCategory(category.id),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _viewModel.selectedCategoryId == category.id
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      category.title,
                      style: TextStyle(
                        color: _viewModel.selectedCategoryId == category.id
                            ? Colors.white
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
    );
    
  }
}