import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/net/api.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/common/utils/navigator_utils.dart';
import 'package:redux/redux.dart';

/// 欢迎页面
class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>  {

  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(hadInit) {
      return;
    }
//    hadInit = true;
    ///防止多次进入
    Store<FMState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    new Future.delayed(const Duration(seconds: 1), () {
      API.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goMyHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<FMState>(
      builder: (context, store) {
        return new Container(
          color: Color(GSYColors.white),
          child: new Center(
            child: new Image(image: new AssetImage('static/images/qddh2.gif')),
          ),
        );
      },
    );
  }

}
