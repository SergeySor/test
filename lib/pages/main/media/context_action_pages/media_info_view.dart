import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/components/login_module/modal_bottom_view.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/open_file/open_file_view.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class MediaInfoView extends StatelessWidget {
  MediaInfoView({Key? key, required this.file}) : super(key: key);
  final MediaInfo file;

  final S translate = getIt<S>();
  @override
  Widget build(BuildContext context) {
    return ModalBottomView(
      headerText: translate.file_info,
      doneButtonText: translate.btn_done,
      onDoneButtonAction: () => Navigator.pop(context),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 80.0,
            right: 80.0,
            top: 45.0,
            bottom: 20.0,
          ),
          child: SvgPicture.asset(file.image),
          //Image.asset(file.image),
        ),
        _wrapWithPadding(
          child: Text(
            file.name,
            textAlign: TextAlign.center,
            style: _normalTextStyle(context).copyWith(fontSize: 18.0),
          ),
        ),
        // _wrapWithPadding(
        //   child: Text(
        //     '${file.size.toString()} byte', //TODO change this hardcode
        //     style: _smallTextStyle(context),
        //     textAlign: TextAlign.left,
        //   ),
        // ),
        _wrapWithPadding(
          child: Divider(
            height: 2,
          ),
        ),
        // _wrapWithPadding(
        //   child: Text(
        //     translate.file_info,
        //     style: _normalTextStyle(context).copyWith(fontSize: 18.0),
        //   ),
        // ),
        _infoRow(context, translate.size, file.size.toString()),
        _infoRow(context, translate.file_type, file.type.toString()),
        // file.type == FileType.folder
        //     ? Container()
        //     :
        // _infoRow(context, translate.file_format, file.type.toString()),
        _infoRow(
            context, translate.file_creation_date, file.createdDate.toString()),
        _infoRow(
            context, translate.file_modify_date, file.modifiedDate.toString()),
        _infoRow(context, translate.file_last_opened_time,
            file.lastOpened.toString()),
        _infoRow(context, translate.file_location, file.location),
        _wrapWithPadding(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  pushNewScreenWithRouteSettings(
                    context,
                    screen: OpenFilePage(),
                    settings:
                        RouteSettings(name: OpenFilePage.args, arguments: file),
                    withNavBar: false,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.0),
                      color: Theme.of(context).cardColor),
                  child: Text(
                    translate.file_open,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _wrapWithPadding({Widget? child}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
      child: child,
    );
  }

  TextStyle _normalTextStyle(BuildContext context) => TextStyle(
        fontFamily: kNormalTextFontFamily,
        fontSize: kNormalTextSize,
        color: Theme.of(context).disabledColor,
      );

  TextStyle _smallTextStyle(BuildContext context) => TextStyle(
        fontFamily: kNormalTextFontFamily,
        fontSize: kSmallTextSize,
        color: Theme.of(context).hintColor,
      );

  Widget _infoRow(
    BuildContext context,
    String key,
    String value,
  ) {
    return Column(
      children: [
        _wrapWithPadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(key, style: _smallTextStyle(context)),
              Text(
                value,
                style: _smallTextStyle(context)
                    .copyWith(color: Theme.of(context).disabledColor),
              )
            ],
          ),
        ),
        _wrapWithPadding(
          child: Divider(
            height: 2,
          ),
        )
      ],
    );
  }
}
