import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/files/open_file/open_file_event.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'open_file_bloc.dart';
import 'open_file_state.dart';

class OpenFilePage extends StatelessWidget {
  OpenFilePage({Key? key}) : super(key: key);
  static const String route = 'open_file_page';
  static const String args = 'open_file_page_args';
  final S translate = getIt<S>();

  final BoxShadow _shadow = BoxShadow(
    color: Color(0xFF073E71).withAlpha(25),
    blurRadius: 4,
    offset: Offset.fromDirection(2, 5),
  );

  @override
  Widget build(BuildContext context) {
    FileInfo file = ModalRoute.of(context)!.settings.arguments as FileInfo;

    return BlocProvider(
      create: (context) => OpenFileBloc()..add(OpenFileInit(file: file)),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).canvasColor,
              ),
              Column(
                children: [
                  _topElement(context),
                  SizedBox(
                    height: 15.0,
                  ),
                  _fileWidget(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topElement(BuildContext context) {
    TextStyle textStyle = TextStyle(
        color: Theme.of(context).textTheme.headline6?.color,
        fontFamily: kNormalTextFontFamily,
        fontSize: kNormalTextSize);
    return BlocBuilder<OpenFileBloc, OpenFileState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            boxShadow: [
              _shadow,
            ],
          ),
          padding: EdgeInsets.only(left: 20.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: textStyle.copyWith(
                      color: Theme.of(context).textTheme.button?.color),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Text(
                  state.file.name,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              TextButton(
                onPressed: () => _showModalPopup(context, state.file),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(20, 10),
                ),
                child: SvgPicture.asset(
                  'assets/more_dots.svg',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fileWidget(BuildContext context) {
    return BlocBuilder<OpenFileBloc, OpenFileState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF073E71).withAlpha(25),
                  blurRadius: 4,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child:
                  state.file.image == '' ? null : Image.asset(state.file.image),
            ),
          ),
        );
      },
    );
  }

  void _showModalPopup(BuildContext blocContext, FileInfo file) {
    TextStyle textStyle = TextStyle(
      color: Theme.of(blocContext).textTheme.headline6?.color,
      fontSize: kSmallTextSize,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle smallTextStyle = TextStyle(
      color: Theme.of(blocContext).textTheme.overline?.color,
      fontSize: 10,
      fontFamily: kNormalTextFontFamily,
    );
    showCupertinoModalPopup(
      context: blocContext,
      useRootNavigator: true,
      builder: (context) {
        return CupertinoActionSheet(
          message: Row(
            children: [
              Image.asset(file.image, height: 55.0, width: 55.0),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      file.name,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: smallTextStyle,
                        text: file.type.toString(),
                        children: [
                          TextSpan(text: ', date: '),
                          TextSpan(text: file.date),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          actions: [
            _getActionSheetAction(
              context,
              'assets/file_context_menu/share.svg',
              translate.file_share,
              () {
                Navigator.pop(context);
                blocContext.read<OpenFileBloc>().add(OpenFileShare());
              },
            ),
            _getActionSheetAction(
              context,
              'assets/file_context_menu/download.svg',
              translate.file_download,
              () {
                Navigator.pop(context);
                blocContext.read<OpenFileBloc>().add(OpenFileDownload());
              },
            ),
            _getActionSheetAction(
              context,
              'assets/file_context_menu/rename.svg',
              translate.file_rename,
              () {
                Navigator.pop(context);
                blocContext.read<OpenFileBloc>().add(OpenFileRename());
              },
            ),
            _getActionSheetAction(
              context,
              'assets/file_context_menu/delete.svg',
              translate.file_delete,
              () {
                Navigator.pop(context);
                blocContext.read<OpenFileBloc>().add(OpenFileDelete());
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              translate.file_close,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: kNormalTextSize,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  Widget _getActionSheetAction(
    BuildContext context,
    String svgPath,
    String text,
    Function() onTap,
  ) {
    TextStyle textStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      color: Theme.of(context).disabledColor,
    );
    return CupertinoActionSheetAction(
      onPressed: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 15.0,
          ),
          SvgPicture.asset(
            svgPath,
            height: 23.0,
            width: 23.0,
            color: Color(0xFFC4C4C4),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
