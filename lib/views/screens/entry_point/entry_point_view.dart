import 'package:biteflow/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biteflow/view-model/entry_point_view_model.dart';

class EntryPointView extends StatefulWidget {
  const EntryPointView({super.key});

  @override
  State<EntryPointView> createState() => _EntryPointViewState();
}

class _EntryPointViewState extends State<EntryPointView> {
  final EntryPointViewModel _viewModel = getIt<EntryPointViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          body: _viewModel.currentScreen,
          bottomNavigationBar: CupertinoTabBar(
            onTap: (value) {
              _viewModel.updateIndex(value);
            },
            currentIndex: _viewModel.selectedIndex,
            activeColor: Colors.blue, // Replace with your primary color
            inactiveColor: Colors.grey, // Replace with your bodyTextColor
            items: List.generate(
              _viewModel.navItems.length,
              (index) => BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _viewModel.navItems[index]['icon'],
                  height: 30,
                  width: 30,
                  colorFilter: ColorFilter.mode(
                    index == _viewModel.selectedIndex
                        ? Colors.blue
                        : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: _viewModel.navItems[index]['title'],
              ),
            ),
          ),
        );
      },
    );
  }
}
