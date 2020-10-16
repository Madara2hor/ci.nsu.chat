import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/search_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/widgets/search_tile.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class SearchView extends StatefulWidget {
  SearchView({Key key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchModel>(
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomPadding: false,
          floatingActionButton: AnimatedContainer(
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
                            textInputAction: TextInputAction.search,
                            controller: _searchController,
                            style: TextStyle(color: AppColors.textColor),
                            onSubmitted: (value) async {
                              await model.searchUser(_searchController.text);
                            },
                            decoration: InputDecoration(
                                hintText: 'Введите имя',
                                hintStyle:
                                    TextStyle(color: AppColors.thirdColor),
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
                        child: Icon(
                          _folded ? Icons.search : Icons.close,
                          color: AppColors.textColor,
                        ),
                      ),
                      onTap: () async {
                        model.refreshUsers();
                        setState(() {
                          _folded = !_folded;
                          _searchController.text = "";
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          body: model.state == ViewState.Busy
              ? _circularProgressIndicator()
              : _buildSearchList(model)),
    );
  }

  Widget _circularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildSearchList(SearchModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 0),
        child: model.users.length != 0
            ? ListView.builder(
                itemCount: model.users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SearchTile(user: model.users[index]),
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.5),
                        indent: 3,
                        endIndent: 3,
                      ),
                    ],
                  );
                })
            : Center(
                child: Text(
                  'Пользователь не найден',
                  style: TextStyle(
                      color: Color(0xffd7d7d7),
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ));
  }
}
