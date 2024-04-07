import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poshpicks/features/home/model/home_model.dart';
import 'package:poshpicks/screens/SignInScreen.dart';
import 'package:poshpicks/test.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/extensions/app_extensions.dart';
import '../../../product/component/card/item_card.dart';
import '../../../product/component/card/special_icon_card.dart';
import '../../../product/component/card/special_text_card.dart';
import '../../../product/component/icon/primary_icon.dart';
import '../../../product/component/image/responsive_image.dart';
import '../../../product/component/text/bold_title.dart';
import '../../../product/component/text/primary_bold_text.dart';
import '../../../product/component/text/product_name.dart';
import '../../../product/component/text/subtitle1_text.dart';
import '../viewmodel/home_view_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final HomeModel model;
  const ProductDetailScreen({super.key, required this.model});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 280,
                  left: 10,
                  right: 10,
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.model.title!,
                          style: TextStyle(fontSize: 30),

                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              '\$ ${widget.model.price.toString()}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),


                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.model.description!,
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFFF7BF50),
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.keyboard_arrow_left_outlined,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border_outlined,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: double.maxFinite,
                            height: 160.0,
                            fit: BoxFit.scaleDown,
                            imageUrl: widget.model.image!,
                            placeholder: (context, url) => const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                )),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/PhotoHub-logos.jpeg',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  static const path = '/home';
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        viewModel: HomeViewModel(),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
          model.fetchItems();
        },
        onPageBuilder: (BuildContext context, HomeViewModel viewModel) {
          Widget isLoading = viewModel.isLoading
              ? _loadingBar(context)
              : _products(context, viewModel);
          return Scaffold(
              backgroundColor: context.groupedBackground,
              appBar: _appBar(context, viewModel),
              body: isLoading);
        },
      );

  AppBar _appBar(BuildContext context, HomeViewModel viewModel) => AppBar(
        backgroundColor: context.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,

        actions: [

          _totalMoney(context, viewModel),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _navigateToSignInScreen(context),
          ),
        ],
      );
  void _navigateToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signinscreen()),
    );
  }


  Padding _totalMoney(BuildContext context, HomeViewModel viewModel) {
    String totalMoney = '\$ ${viewModel.totalPrice}';
    return Padding(
      padding: context.horizontalPaddingNormal,
      child: ActionChip(
        backgroundColor: context.secondaryBackground,
        // Total money text
        label: PrimaryBoldText(context: context, data: totalMoney),
        // Shop icon
        avatar: PrimaryIcon(icon: Icons.shopping_bag, context: context),
        onPressed: () => _showModalBottomSheet(context, viewModel),
      ),
    );
  }

  // Loading widget
  Center _loadingBar(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
        ),
      );

  // Body widget
  void _goToNextPage(BuildContext context, HomeModel model) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetailScreen(model: model);
    }));
  }

  ElasticInDown _products(BuildContext context, HomeViewModel viewModel) =>
      ElasticInDown(
        duration: context.durationSlow,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) => Padding(
            padding: context.paddingLow,
            child: ItemCard(
              context: context,
              model: viewModel.items[index],
              viewModel: viewModel,
              callback: () {
                _goToNextPage(context, viewModel.items[index]);
              },
            ),
          ),
        ),
      );

  // Basket Menu
  void _showModalBottomSheet(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: context.normalBorderRadius),
      backgroundColor: context.groupedBackground,
      builder: (context) => viewModel.basketItems.isEmpty
          ? _emptyBasket(context)
          : StatefulBuilder(builder: (context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _basketItems(context, viewModel, setState),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the signup page
                  _navigateToSignUpScreen(context);
                },
                child: Text('Locate Store'),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _navigateToSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => locateStore()),
    );
  }


  FlipInY _emptyBasket(BuildContext context) => FlipInY(
        child: Center(
          child: Padding(
            padding: context.paddingLow,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                PrimaryIcon(icon: Icons.shopping_cart, context: context),
                context.emptySizedWidthBoxLow3x,
                Subtitle1Text(
                  data: 'Your basket is currently empty.',
                  context: context,
                  color: context.primaryColor,
                ),

              ],
            ),
          ),
        ),
      );

  ListView _basketItems(BuildContext context, HomeViewModel viewModel,
          StateSetter setState) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: context.paddingMedium,
        itemBuilder: (context, index) =>
            _basketItem(context, viewModel, index, setState),
        separatorBuilder: (context, index) => context.emptySizedHeightBoxLow,
        itemCount: viewModel.basketItems.length,
      );

  JelloIn _basketItem(BuildContext context, HomeViewModel viewModel, int index,
          StateSetter setState) =>
      JelloIn(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: context.normalBorderRadius),
          child: Padding(
            padding: context.paddingLow,
            child: ListTile(
              leading: ResponsiveImage(
                  aspectRaito: 1,
                  imageUrl: viewModel.basketItems[index].image ?? ""),
              title: ProductName(
                data: viewModel.basketItems[index].title ?? 'Title is null !',
              ),
              subtitle:
                  _priceCountAndButtons(context, viewModel, index, setState),
            ),
          ),
        ),
      );

  Column _priceCountAndButtons(BuildContext context, HomeViewModel viewModel,
          int index, StateSetter setState) =>
      Column(
        children: [
          _pricesAndCount(context, viewModel, index),
          context.emptySizedHeightBoxLow,
          _buttons(setState, viewModel, index, context),
        ],
      );

  Wrap _pricesAndCount(
          BuildContext context, HomeViewModel viewModel, int index) =>
      Wrap(
        children: [
          // Price Text
          PrimaryBoldText(
            context: context,
            data:
                'Price: ${viewModel.basketItems[index].productPrice.toString()} \$',
          ),
          context.emptySizedWidthBoxLow2x,
          PrimaryBoldText(
            context: context,
            data:
                'Count: ${viewModel.basketItems[index].count.toString().substring(0, 1)}',
          ),
        ],
      );

  Row _buttons(StateSetter setState, HomeViewModel viewModel, int index,
          BuildContext context) =>
      Row(
        children: [
          GestureDetector(
            onTap: () => setState(
                () => viewModel.incrementCount(viewModel.basketItems[index])),
            child: SpecialIconCard(context: context, icon: Icons.add),
          ),
          // Count card
          SpecialTextCard(
            context: context,
            data: viewModel.basketItems[index].count.toString().substring(0, 1),
          ),
          // Deincrement count button
          GestureDetector(
            onTap: () {
              setState(() {
                viewModel.deIncrementCount(viewModel.basketItems[index]);
                if (viewModel.basketItems[index].count == 0) {
                  viewModel.basketItems.removeAt(index);
                }
              });
            },
            child: SpecialIconCard(
              context: context,
              icon: Icons.remove,
            ),
          ),
        ],
      );
}
