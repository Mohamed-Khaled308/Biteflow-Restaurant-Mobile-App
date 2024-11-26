// import 'package:flutter/material.dart';
// import 'package:biteflow/locator.dart';
// import 'package:biteflow/view-model/manager_create_item_view_model.dart';

// class CreateMenuCategory extends StatefulWidget {
//   const CreateMenuCategory({super.key});

//   @override
//   State<CreateMenuCategory> createState() => _CreateMenuCategoryState();
// }

// class _CreateMenuCategoryState extends State<CreateMenuCategory> {
  
//   final ManagerCreateItemViewModel _viewModel =
//       getIt<ManagerCreateItemViewModel>();
  
//   @override
//   Widget build(BuildContext context) {
//     // return AnimatedBuilder(
//     //     animation: _viewModel,
//     //     builder: (context, _) {
//           return Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _viewModel.categoryNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Category Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _viewModel.createCategory();
//                       print('ana henaaa');
//                       Navigator.pop(context); // Close the bottom sheet
//                     },
//                     child: const Text('Save Category'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         // });
//   }
// }