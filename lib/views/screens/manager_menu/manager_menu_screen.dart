import 'package:biteflow/services/navigation_service.dart';
// import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/views/screens/feedback/feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/views/screens/manager_menu/components/categories_list.dart';
import 'package:biteflow/views/screens/manager_menu/components/create_item_category.dart';
import 'package:biteflow/views/screens/manager_menu/components/items_list.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/core/constants/theme_constants.dart';

class ManagerMenuScreen extends StatefulWidget {
  const ManagerMenuScreen({super.key});

  @override
  State<ManagerMenuScreen> createState() => _ManagerMenuScreenState();
}

class _ManagerMenuScreenState extends State<ManagerMenuScreen> {
  late ScrollController _scrollController;
  double _placeholderOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _placeholderOpacity = (_scrollController.offset < 200)
              ? 1 - (_scrollController.offset / 200)
              : 0;
        });
      });
  }

  // @override
  // // ignore: must_call_super
  // void dispose() {
  //   // _scrollController.dispose();
  //   // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerMenuViewModel>();

    if (viewModel.busy || viewModel.authenticatedManagerRestaurant == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Loading...'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            backgroundColor: ThemeConstants.blackColor40,
            color: ThemeConstants.blackColor80,
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Text(
          viewModel.authenticatedManagerRestaurant!.name,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: ThemeConstants.whiteColor,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                getIt<NavigationService>().navigateTo(
                  FeedbackView(
                    restaurantId: viewModel.authenticatedManagerRestaurant!.id,
                  ),
                );
              },
              icon: const Icon(
                Icons.rate_review_rounded,
                color: ThemeConstants.whiteColor,
              ),
              tooltip: 'View Restaurant Feedback',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Restaurant Image Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _placeholderOpacity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      viewModel.authenticatedManagerRestaurant!.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.restaurant,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Card(
                        color: Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: ThemeConstants.warningColor,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                viewModel.authenticatedManagerRestaurant!.rating
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${viewModel.authenticatedManagerRestaurant!.reviewCount} reviews)',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Section
          if (viewModel.categories == null || viewModel.categories!.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Menu Items Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start by adding your first menu item',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     showModalBottomSheet(
                    //         context: context,
                    //         isScrollControlled: true,
                    //         shape: const RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.vertical(
                    //             top: Radius.circular(20),
                    //           ),
                    //         ),
                    //         builder: (context) {
                    //           return ChangeNotifierProvider.value(
                    //             value: viewModel,
                    //             child: SizedBox(
                    //               height:
                    //                   MediaQuery.of(context).size.height * 0.75,
                    //               child: CreateItemCategory(
                    //                   categories: viewModel.categories),
                    //             ),
                    //           );
                    //           // return ChangeNotifierProvider(
                    //           //   create: (_) => getIt<ManagerCreateItemViewModel>(),
                    //           //   child: SizedBox(
                    //           //     height: MediaQuery.of(context).size.height * 0.75,
                    //           //     child: CreateItemCategory(
                    //           //         categories: viewModel.categories),
                    //           //   ),
                    //           // );
                    //         });
                    //   },
                    //   icon: const Icon(Icons.add),
                    //   label: const Text('Add First Item'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Theme.of(context).primaryColor,
                    //     foregroundColor: ThemeConstants.whiteColor,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 24,
                    //       vertical: 16,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CategoriesList(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: const ItemsList(),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
                return ChangeNotifierProvider.value(
                  value: viewModel,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: CreateItemCategory(categories: viewModel.categories),
                  ),
                );
                // return ChangeNotifierProvider(
                //   create: (_) => getIt<ManagerCreateItemViewModel>(),
                //   child: SizedBox(
                //     height: MediaQuery.of(context).size.height * 0.75,
                //     child: CreateItemCategory(
                //         categories: viewModel.categories),
                //   ),
                // );
              });
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: ThemeConstants.whiteColor),
        label: const Text(
          'Add Item',
          style: TextStyle(color: ThemeConstants.whiteColor),
        ),
      ),
    );
  }

  // void _showCreateItemSheet(BuildContext context, ManagerMenuViewModel viewModel) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(20),
  //       ),
  //     ),
  //     builder: (context) {
  //       return ChangeNotifierProvider(
  //         create: (_) => getIt<ManagerCreateItemViewModel>(),
  //         child: SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.75,
  //           child: CreateItemCategory(
  //             categories: viewModel.categories ?? [],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
