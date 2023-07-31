import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:section21/constant/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  // true 시간, false 내용
  final bool isTime;

  final FormFieldSetter<String> onSaved;

  final String initialValue;

  const CustomTextField(
      {super.key,
      required this.label,
      required this.isTime,
      required this.onSaved,
      required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    // FormField - 서로 다른 TextField를 동시에 관리하기 용이함 (A, B, C, .. 여러 텍스트를 통합하려 관리 가능)
    return TextFormField(
      // 에러 검증 후 저장
      onSaved: onSaved,

      // 에러 검증 - null이 return 될 경우 에러가 없음, 있을 경우 String 값으로 return
      // 상위 Form에서 validate 할 경우 하위 FormField의
      validator: (String? value) {
        // value 값이 null이거나 입력되지 않았을 경우
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요.';
        }

        // 시간 입력 포맷의 경우
        if (isTime) {
          int time = int.parse(value);

          if (time < 0) {
            return '0 이상의 시간을 입력해주세요.';
          }

          if (time > 24) {
            return '24이하의 시간을 입력해주세요.';
          }
        } else {
          // 내용 입력 포맷의 경우
          if (value.length > 500) {
            return '500이하의 내용을 입력해주세요.';
          }
        }

        // 에러가 없을 경우 (default)
        return null;
      },

      // 커서 색
      cursorColor: Colors.grey,
      // 최대 줄 개수 - 1 (default), null (infinite)
      maxLines: isTime ? 1 : null,
      // 키보드 타입
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 입력 양식 제한
      inputFormatters: isTime
          ? [
              // 숫자만 입력 가능
              FilteringTextInputFormatter.digitsOnly
            ]
          : [],
      // expand 적용 유뮤
      expands: isTime ? false : true,
      // 기본값
      initialValue: initialValue,
      // 데코레이션
      decoration: InputDecoration(
        // 밑줄 유무
        border: InputBorder.none,
        // 배경색 유무
        filled: true,
        // 배경색
        fillColor: Colors.grey[300],
        // 접미사, 뒤에 - suffix
        // 접두사, 앞에 - prefix
        // 뒤에 붙는 글자
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
