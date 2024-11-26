import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biteflow/viewmodels/entry_point_view_model.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:provider/provider.dart';

class EntryPointScreen extends StatelessWidget {
  const EntryPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EntryPointViewModel>();

    return Scaffold(
      body: viewModel.currentScreen,
      bottomNavigationBar: CupertinoTabBar(
        onTap: (value) {
          viewModel.updateIndex(value);
        },
        currentIndex: viewModel.selectedIndex,
        activeColor: ThemeConstants.primaryColor,
        inactiveColor: ThemeConstants.greyColor,
        items: List.generate(
          viewModel.navItems.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              viewModel.navItems[index]['icon'],
              height: 30,
              width: 30,
              colorFilter: ColorFilter.mode(
                index == viewModel.selectedIndex
                    ? ThemeConstants.primaryColor
                    : ThemeConstants.greyColor,
                BlendMode.srcIn,
              ),
            ),
            label: viewModel.navItems[index]['title'],
          ),
        ),
      ),
    );
  }
}
