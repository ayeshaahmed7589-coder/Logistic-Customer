import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class MainOrderCreateScreen extends StatefulWidget {
  const MainOrderCreateScreen({super.key});

  @override
  State<MainOrderCreateScreen> createState() => _MainOrderCreateScreenState();
}

class _MainOrderCreateScreenState extends State<MainOrderCreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = [
    Tab(text: "PickUp Location"),
    Tab(text: "Package Details"),
  ];

  final List<Widget> _tabsBody = const [
    PickupDeliveryScreen(),
    PackageDetailsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabsBody.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: AppColors.pureWhite),
          ),
        ),
        title: CustomText(
          txt: "Create Order",
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        // App bar se CustomTabBar hata diya
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CustomTabBar yahan body ke top par
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomTabBar(
                tabController: _tabController,
                tabs: _tabs,
                color: AppColors.electricTeal,
              ),
            ),
            // TabBarView neechay
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabsBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTabBar extends StatefulWidget {
  final Color color;
  final List<int>? disabledTabIndices;
  final TabController tabController;

  CustomTabBar({
    super.key,
    // required TabController tabController,
    required this.tabController,
    required List<Tab> tabs,
    this.width = 250,
    this.color = Colors.black,
    this.disabledTabIndices,
  }) : _tabController = tabController,
       _tabs = tabs;

  final TabController _tabController;
  final List<Tab> _tabs;
  double width = 250;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.electricTeal),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: widget.width,
        height: kToolbarHeight - 17.0,
        child: Row(
          children: List.generate(widget._tabs.length, (index) {
            final isDisabled =
                widget.disabledTabIndices?.contains(index) == true;
            final isSelected = widget._tabController.index == index;

            return Expanded(
              child: GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        widget._tabController.animateTo(index);
                      },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  // decoration: BoxDecoration(
                  //   color: isSelected
                  //       ? AppColors.secondaryButtonColor
                  //       : (isDisabled
                  //           ? Colors.grey.shade300
                  //           : Colors.transparent),
                  //   borderRadius: BorderRadius.circular(8.0),
                  // ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.electricTeal
                        : (isDisabled
                              ? Colors.grey.shade300
                              : Colors.transparent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: CustomText(
                      txt: widget._tabs[index].text ?? '',
                      align: TextAlign.center,

                      fontSize: 14,
                      fontWeight: FontWeight.w600,

                      // color: isSelected
                      //     ? UtilsHelper.getWhiteTextColor(context)
                      //     : (isDisabled ? Colors.grey.shade600 : color),
                      color: isSelected
                          ? UtilsHelper.getWhiteTextColor(context)
                          : (isDisabled ? Colors.grey.shade600 : widget.color),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class UtilsHelper {
  static bool isInternetAvalible = true;

  static getCanvasColor(BuildContext context) {
    return Theme.of(context).canvasColor;
  }

  static setCacheNetworkImage(
    String imageUrl, {
    double? height,
    double? width,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height ?? 100,
      width: width ?? 200,
      fit: BoxFit.fill,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height ?? 95,
          // width: width ?? 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // placeholder: (context, url) => Center(
      //   child: CustomLoader(), // Loading indicator
      // ),
      errorWidget: (context, url, error) =>
          Icon(Icons.image_outlined, size: 50, color: Colors.blue),
    );
  }

  static Color getWhiteTextColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.pureWhite : AppColors.pureWhite;
  }

  static bool isDarkMode(BuildContext context) {
    // final Brightness brightnessValue =
    //     MediaQuery.of(context).platformBrightness;
    // return brightnessValue == Brightness.dark;
    return false;
  }

  static void showToast(String s) {}
}
