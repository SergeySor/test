import 'package:flutter/material.dart';
import 'package:upstorage/components/login_module/modal_bottom_view.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class FileRenameView extends StatelessWidget {
  FileRenameView({
    Key? key,
    required this.file,
    required this.onDone,
  }) : super(key: key);
  final FileInfo file;
  final Function(String) onDone;
  final S translate = getIt<S>();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = file.name;
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom + 15;
    return ModalBottomView(
      headerText: translate.file_rename,
      doneButtonText: translate.btn_done,
      onDoneButtonAction: () => _onDoneAction(context),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 80.0,
            right: 80.0,
            top: 45.0,
            bottom: 15.0,
          ),
          child: Image.asset(file.image),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 50.0,
            right: 50.0,
            bottom: bottomPadding,
          ),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).hintColor,
            ),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => _onDoneAction(context),
              autofocus: true,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onDoneAction(BuildContext context) {
    Navigator.pop(context);
    onDone(controller.text);
  }
}
