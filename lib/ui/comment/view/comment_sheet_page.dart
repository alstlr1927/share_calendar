import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:couple_calendar/ui/comment/view_model/comment_sheet_view_model.dart';
import 'package:couple_calendar/ui/comment/widgets/comment_item.dart';
import 'package:couple_calendar/ui/common/components/drag_to_dispose/drag_to_dispose.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';
import '../../common/components/couple_text_field/couple_text_field.dart';
import '../../common/components/custom_button/couple_button.dart';

class CommentSheetPage extends StatefulWidget {
  final String scheduleId;

  const CommentSheetPage({
    super.key,
    required this.scheduleId,
  });

  @override
  State<CommentSheetPage> createState() => _CommentSheetPageState();
}

class _CommentSheetPageState extends State<CommentSheetPage> {
  late CommentSheetViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CommentSheetViewModel(this, scheduleId: widget.scheduleId);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommentSheetViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DragToDispose(
          onPageClosed: () => context.pop(),
          maxHeight: ScreenUtil().screenHeight * .55 +
              MediaQuery.of(context).viewInsets.bottom,
          dragEnable: true,
          backdropTapClosesPanel: true,
          panelBuilder: (sc, ac) {
            sc.addListener(() => viewModel.scrollListener(sc.position));
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => viewModel.fieldController.unfocus(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CoupleStyle.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.toWidth),
                    child: Column(
                      children: [
                        _handle(),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: sc,
                            child: Selector<CommentSheetViewModel,
                                List<CommentModel>>(
                              selector: (_, vm) => vm.commentList,
                              builder: (_, list, __) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.toWidth,
                                    vertical: 8.toHeight,
                                  ),
                                  child: Column(
                                    children: list
                                        .map((comment) =>
                                            CommentItem(comment: comment)
                                                as Widget)
                                        .superJoin(SizedBox(height: 6.toHeight))
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        _buildInputFieldArea(),
                        AnimatedContainer(
                          duration: Duration.zero,
                          height:
                              MediaQuery.of(context).viewInsets.bottom == 0.0
                                  ? MediaQuery.of(context).viewInsets.bottom +
                                      CoupleStyle.defaultBottomPadding()
                                  : MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputFieldArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
      child: Row(
        children: [
          Expanded(
            child: CoupleTextField(
              controller: viewModel.fieldController,
            ),
          ),
          SizedBox(width: 10.toWidth),
          CoupleButton(
            onPressed: viewModel.onClickSendComment,
            option: CoupleButtonOption.text(
              text: '전송',
              theme: CoupleButtonTextTheme.subBlue,
              style: CoupleButtonTextStyle.small,
            ),
          ),
        ],
      ),
    );
  }

  Widget _handle() {
    return Column(
      children: [
        SizedBox(height: 8.toHeight),
        Container(
          width: 80.toWidth,
          height: 6,
          decoration: BoxDecoration(
            color: CoupleStyle.gray050,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        SizedBox(
          height: 10.toHeight,
        ),
      ],
    );
  }
}
