//
import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

class DropDownContainer extends StatefulWidget {
  final String text;
  final Widget dialogueScreen;
  final FontWeight fw;
  final ValueChanged<String>? onItemSelected; // Callback for selection
  final bool? isIconVisible;
  final Color? textColor;

  const DropDownContainer({
    super.key,
    required this.text,
    required this.dialogueScreen,
    this.fw = FontWeight.w600,
    this.onItemSelected,
    this.isIconVisible = true,
    this.textColor,
  });

  @override
  State<DropDownContainer> createState() => _DropDownContainerState();
}

class _DropDownContainerState extends State<DropDownContainer> {
  String? selectedText;

  Future<String?> _showDropDownDialog(BuildContext context) async {
    // Show dialog and return the result directly
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(child: widget.dialogueScreen);
      },
    );

    if (result != null) {
      setState(() {
        selectedText = result; // Update the UI with the selected text
      });

      if (widget.onItemSelected != null) {
        widget.onItemSelected!(result); // Call the callback if provided
      }
    }

    return result; // Return the selected result
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await _showDropDownDialog(context);
        if (result != null) {
          // Handle the result outside if needed
          print('Selected value: $result');
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 15),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedText != null
                ? AppColors.electricTeal
                : AppColors.lightBorder,
          ),
          color: selectedText != null
              ? AppColors.pureWhite
              : AppColors.pureWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomText(
                    txt: selectedText ?? widget.text,
                    // style: addTextStyle(
                    fontSize: 16,
                    color: widget.textColor ?? AppColors.darkText,
                    fontWeight: FontWeight.w500,
                    // ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (widget.isIconVisible == true)
              IconButton(
                onPressed: () async {
                  final result = await _showDropDownDialog(context);
                  if (result != null) {
                    print('Selected: $result');
                  }
                },
                icon: Icon(Icons.keyboard_arrow_down_outlined),

                //  SvgPicture.asset(
                //   AppImages.arrowDownIcon,
                //   colorFilter: ColorFilter.mode(
                //     isDarkMode ? whiteColor : blackColor,
                //     BlendMode.srcIn,
                //   ),
                // ),
              ),
          ],
        ),
      ),
    );
  }
}

class MaterialConditionPopupLeftIcon extends StatefulWidget {
  final List<String>? conditions;
  final String? title;
  final Function? onSelect;
  final BorderRadiusGeometry? borderRadius;
  final double height;
  final double verticalPadding;
  final int? initialSelectedIndex;
  final Function(String)? onItemSelected;
  final bool enableSearch;

  const MaterialConditionPopupLeftIcon({
    super.key,
    this.conditions,
    this.title,
    this.onSelect,
    this.borderRadius,
    this.height = 50,
    this.verticalPadding = 0,
    this.initialSelectedIndex,
    this.onItemSelected,
    this.enableSearch = false,
  });

  @override
  State<MaterialConditionPopupLeftIcon> createState() =>
      _MaterialConditionPopupLeftIconState();
}

class _MaterialConditionPopupLeftIconState
    extends State<MaterialConditionPopupLeftIcon> {
  int? selectedIndex;
  List<String>? filteredConditions;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredConditions = widget.conditions;
    searchController.addListener(_filterConditions);
    selectedIndex = widget.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(MaterialConditionPopupLeftIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conditions != oldWidget.conditions ||
        widget.initialSelectedIndex != oldWidget.initialSelectedIndex) {
      filteredConditions = widget.conditions;
      selectedIndex = widget.initialSelectedIndex;
    }
  }

  void _filterConditions() {
    if (widget.enableSearch) {
      String query = searchController.text.toLowerCase();
      setState(() {
        filteredConditions = widget.conditions!
            .where((condition) => condition.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bluetextColor = isDarkMode ? Colors.white : AppColors.darkText;

    return Container(
      padding: const EdgeInsets.only(left: 4, right: 6, top: 4),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional search bar
          if (widget.enableSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1, // thin border
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

          // Options list
          Flexible(
            child: ListView.builder(
              itemCount: filteredConditions?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                int? selectedIndex = this.selectedIndex;
                final isSelected =
                    selectedIndex != null &&
                    selectedIndex >= 0 &&
                    widget.conditions != null &&
                    selectedIndex < widget.conditions!.length &&
                    filteredConditions![index] ==
                        widget.conditions![selectedIndex];

                return InkWell(
                  onTap: () {
                    if (widget.conditions != null) {
                      final originalIndex = widget.conditions!.indexOf(
                        filteredConditions![index],
                      );
                      setState(() {
                        this.selectedIndex = originalIndex;
                      });

                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(
                          widget.conditions![originalIndex],
                        );
                      } else {
                        Navigator.pop(
                          context,
                          widget.conditions![originalIndex],
                        );
                      }
                    }
                  },

                  child: Container(
                    height: widget.height,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: widget.verticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.electricTeal.withOpacity(0.08)
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.mediumGray.withOpacity(0.20),
                          //  Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? Colors.green
                              : (isDarkMode ? Colors.white38 : Colors.black38),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            txt: filteredConditions![index],
                            fontSize: 16,
                            color: isSelected ? bluetextColor : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



// Consumer(
//   builder: (context, ref, child) {
//     // Static countries list
//     final List<Map<String, dynamic>> staticCountries = [
//       {"countryID": 1, "countryName": "Pakistan"},
//       {"countryID": 2, "countryName": "India"},
//       {"countryID": 3, "countryName": "USA"},
//       {"countryID": 4, "countryName": "UK"},
//       {"countryID": 5, "countryName": "UAE"},
//     ];

//     // Find selected country safely
//     final hasSelectedCountry = staticCountries.any(
//       (e) => e["countryID"] == selectedCountryID,
//     );

//     final selectedCountryName = hasSelectedCountry
//         ? staticCountries
//             .firstWhere((e) => e["countryID"] == selectedCountryID)["countryName"]
//         : "Select Country";

//     final countryIndex = hasSelectedCountry
//         ? staticCountries.indexWhere((s) => s["countryID"] == selectedCountryID)
//         : null;

//     return DropDownContainer(
//       fw: FontWeight.normal,
//       dialogueScreen: MaterialConditionPopupLeftIcon(
//         title: '',
//         conditions: staticCountries
//             .map((e) => e["countryName"] as String)
//             .toList(),
//         initialSelectedIndex: countryIndex,
//       ),
//       text: selectedCountryName,
//       onItemSelected: (value) {
//         final selectedItem = staticCountries.firstWhere(
//           (e) => e["countryName"] == value,
//         );
//         setState(() {
//           selectedCountryID = selectedItem["countryID"] as int;
//           _validateFields();
//         });
//       },
//     );
//   },
// ),