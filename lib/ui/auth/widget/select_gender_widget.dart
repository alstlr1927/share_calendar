import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

class SelectGenderWidget extends StatefulWidget {
  final UserGender initValue;
  final Function(UserGender)? onChanged;

  const SelectGenderWidget({
    super.key,
    this.initValue = UserGender.NONE,
    this.onChanged,
  });

  @override
  State<SelectGenderWidget> createState() => _SelectGenderWidgetState();
}

class _SelectGenderWidgetState extends State<SelectGenderWidget> {
  late UserGender curGender;

  @override
  void initState() {
    super.initState();
    curGender = widget.initValue;
  }

  void setCurGender(UserGender gender) {
    curGender = gender;
    setState(() {});
    widget.onChanged?.call(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: UserGender.values
          .map((e) => _buildGenderButton(e))
          .superJoin(SizedBox(width: 14.toWidth))
          .toList(),
    );
  }

  Widget _buildGenderButton(UserGender gender) {
    final text = gender == UserGender.NONE ? '설정안함' : gender.typeKr;
    final baseColor =
        gender == curGender ? CoupleStyle.primary050 : CoupleStyle.gray030;
    final textColor =
        gender == curGender ? CoupleStyle.white : CoupleStyle.gray090;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 7 / 3,
        child: BaseButton(
          onPressed: () => setCurGender(gender),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: baseColor,
            ),
            child: Text(
              text,
              style: CoupleStyle.body1(
                weight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
