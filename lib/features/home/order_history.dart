import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/constants/gap.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String selectedLabel = '';
  // ignore: unused_field
  String _currentSubStatus = '';
  final Map<String, String> subStatusMap = {
    'All': '',
    'Active': '24',
    'Past': '11',
  };
  final List<Map<String, dynamic>> _buttonData = [
    {'label': "All", 'icon': null},
    {'label': "Active", 'icon': null},
    {'label': "Past", 'icon': null},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.electricTeal,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(0, 3),
                //   )
                // ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- LEFT SIDE (Close Icon) ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: AppColors.pureWhite),
                    ),
                  ),

                  // --- CENTER TITLE ---
                  CustomText(
                    txt: "Order History",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ],
              ),
            ),

            //appbar end
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [

                  CustomButtonSlider(
                    buttonData: _buttonData,
                    onIndexChanged: (index) {
                      final selected = _buttonData[index]['label'];
                      final mappedStatus = subStatusMap[selected] ?? '';

                      setState(() {
                        selectedLabel = selected;
                        _currentSubStatus = mappedStatus;
                      });
                    },
                  ),


                  gapH16,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              txt: "Order: ",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.electricTeal,
                            ),
                            CustomText(
                              txt: "12345",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkText,
                            ),
                          ],
                        ),
                        gapH8,
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: AppColors.electricTeal,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 6),
                            CustomText(
                              txt: "In Transit",
                              color: AppColors.mediumGray,
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            CustomText(
                              txt: "ETA: ",
                              color: AppColors.electricTeal,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            CustomText(
                              txt: "15 minutes",
                              color: AppColors.mediumGray,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        gapH8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  txt: "View Details",
                                  color: AppColors.electricTeal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                gapW4,
                                Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: AppColors.electricTeal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  gapH8,

                  buildOrderTile("12344", "Delivered", "Jan 14, 3:20 PM"),
                  gapH12,
                  buildOrderTile("12343", "Delivered", "Jan 13, 11:15 AM"),
                  gapH12,
                  buildOrderTile("12343", "Delivered", "Jan 13, 11:15 AM"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderTile(String id, String status, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                txt: id,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              gapW8,
              const Icon(Icons.check, color: Colors.green, size: 18),
              CustomText(txt: " $status", color: Colors.green),
            ],
          ),
          const SizedBox(height: 6),
          CustomText(txt: time, fontSize: 12),
        ],
      ),
    );
  }
}

class CustomButtonSlider extends StatefulWidget {
  final List<Map<String, dynamic>> buttonData;
  final Function(int) onIndexChanged;
  final int initialIndex;

  const CustomButtonSlider({
    super.key,
    required this.buttonData,
    required this.onIndexChanged,
    this.initialIndex = 0,
  });

  @override
  _CustomButtonSliderState createState() => _CustomButtonSliderState();
}

class _CustomButtonSliderState extends State<CustomButtonSlider> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.buttonData.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onIndexChanged(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: _selectedIndex == index
                        ? AppColors.electricTeal
                        : Colors.white,
                    border: Border.all(
                      color: _selectedIndex == index
                          ? Colors.transparent
                          : Colors.black12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Check if there is an icon in the buttonData
                      if (widget.buttonData[index]['icon'] != null &&
                          widget.buttonData[index]['label'] != 'All') ...[
                        Icon(
                          widget.buttonData[index]['icon'],
                          color: _selectedIndex == index
                              ? Colors.white
                              : AppColors.darkText,
                        ),
                        const SizedBox(width: 8),
                      ]
                      // Check if there is an image (SVG) in the buttonData
                      else if (widget.buttonData[index]['image'] != null) ...[
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == index
                                ? Colors.white
                                : AppColors
                                      .darkText, // Set the color based on selection
                            BlendMode.srcIn,
                          ),
                          child: widget.buttonData[index]['image'],
                        ),
                        const SizedBox(width: 8),
                      ],
                      CustomText(
                        txt: widget.buttonData[index]['label'],
                        color: _selectedIndex == index
                            ? Colors.white
                            : AppColors.darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
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
