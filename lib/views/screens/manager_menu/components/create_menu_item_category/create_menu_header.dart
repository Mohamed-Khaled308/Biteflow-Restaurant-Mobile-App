// import 'package:flutter/material.dart';
// import 'package:biteflow/locator.dart';
// import 'package:biteflow/view-model/manager_create_item_view_model.dart';

// class CreateMenuHeader extends StatefulWidget {
//   const CreateMenuHeader({super.key});

//   @override
//   State<CreateMenuHeader> createState() => _CreateMenuHeaderState();
// }

// class _CreateMenuHeaderState extends State<CreateMenuHeader> {
  
//   final ManagerCreateItemViewModel _viewModel =
//       getIt<ManagerCreateItemViewModel>();

//   @override
//   Widget build(BuildContext context) {
//     // return AnimatedBuilder(
//     //     animation: _viewModel,
//     //     builder: (context, _) {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 _viewModel.isCreatingItem ? 'Create New Item' : 'Create New Category',
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               // IconButton(
//               //   icon: Icon(
//               //     _viewModel.isCreatingItem ? Icons.category : Icons.fastfood,
//               //     color: Theme.of(context).primaryColor,
//               //   ),
//               //   onPressed: () {
//               //     _viewModel.updateIsCreatingItem(!_viewModel.isCreatingItem);
//               //   },
//               // ),
//             ],
//           );
//         // });
//   }
// }