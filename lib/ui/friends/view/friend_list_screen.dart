import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/friends/view_model/friend_list_view_model.dart';
import 'package:couple_calendar/ui/friends/widgets/friend_list_item.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  late FriendListViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = FriendListViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FriendListViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return GestureDetector(
          onTap: viewModel.focusout,
          child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                _buildInputField(),
                _buildFriendListView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 16.toWidth, vertical: 6.toHeight),
      child: SizedBox(
        height: 28.toHeight,
        child: TextField(
          controller: viewModel.textController,
          focusNode: viewModel.focusNode,
          decoration: InputDecoration(
            counterText: '',
            hintText: '이름으로 검색',
            hintStyle: CoupleStyle.body2(
                color: CoupleStyle.gray060, weight: FontWeight.w600),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.toWidth),
            filled: true,
            fillColor: CoupleStyle.gray030,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: CoupleStyle.subBlue, width: 3.toWidth),
            ),
          ),
          cursorHeight: 14.toHeight,
        ),
      ),
    );
  }

  Widget _buildFriendListView() {
    return Consumer<UserProvider>(
      builder: (_, userProv, __) {
        final friendList = userProv.friendList;
        return Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(
                parent: const BouncingScrollPhysics()),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.toWidth),
                    child: Text(
                      '친구 ${friendList.length}',
                      style: CoupleStyle.caption(
                        color: CoupleStyle.gray070,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.toHeight),
                  ...friendList
                      .map((friend) => FriendListItem(user: friend) as Widget)
                      .superJoin(SizedBox(height: 10.toHeight))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 22.toWidth, bottom: 10.toHeight),
      child: Row(
        children: [
          Text(
            '친구 목록',
            style: CoupleStyle.h3(
              color: CoupleStyle.gray090,
              weight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          BaseButton(
            onPressed: viewModel.onClickAddFrindBtn,
            child: Icon(
              Icons.add,
              size: 26.toWidth,
            ),
          ),
          SizedBox(width: 12.toWidth),
        ],
      ),
    );
  }
}
