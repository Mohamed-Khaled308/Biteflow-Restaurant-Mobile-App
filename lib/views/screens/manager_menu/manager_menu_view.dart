import 'package:biteflow/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/view-model/manager_menu_view_model.dart';
import 'package:biteflow/views/screens/manager_menu/components/categories_list.dart';
import 'package:biteflow/views/screens/manager_menu/components/create_menu_item.dart';


class ManagerMenuView extends StatefulWidget {
  const ManagerMenuView({super.key});

  @override
  State<ManagerMenuView> createState() => _ManagerMenuViewState();
}

class _ManagerMenuViewState extends State<ManagerMenuView> {

  final ManagerMenuViewModel _viewModel =  getIt<ManagerMenuViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              _viewModel.restaurantName,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: ThemeConstants.whiteColor,
              )
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const Column(
            children: [
              SizedBox(height: 10),
              CategoriesList(),
              SizedBox(height: 10),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const CreateMenuItem(),
                  );
                }
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add, color: ThemeConstants.whiteColor),
          ),
        );
      }
      
    );
  }
}