import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function onTap;
  final Function onSubmitted;

  AnimatedSearchBar(
      {@required this.searchController,
      @required this.onTap,
      @required this.onSubmitted});

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _folded ? 56 : 200,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppColors.secondColor,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                      controller: widget.searchController,
                      style: TextStyle(color: AppColors.textColor),
                      onSubmitted: (value) => widget.onSubmitted(),
                      decoration: InputDecoration(
                          hintText: 'Введите имя',
                          hintStyle: TextStyle(color: AppColors.textColor),
                          border: InputBorder.none),
                    )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image(
                      color: AppColors.textColor,
                      height: 24,
                      width: 24,
                      image: _folded
                          ? AssetImage('assets/icons/magnifying-glass.png')
                          : AssetImage('assets/icons/cancel.png')),
                ),
                onTap: () {
                  widget.onTap();
                  setState(() {
                    _folded = !_folded;
                    widget.searchController.text = "";
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
