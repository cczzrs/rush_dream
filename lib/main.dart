import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/dataModel/show.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/main2.dart';
import 'package:rush_dream/page/widget/slide_container.dart';

//void main() => runApp(MyApp());
void main() => main2();

void main3() {
  runApp(new FlutterReduxApp());
  debugPaintSizeEnabled = true;
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FlutterReduxApp extends StatelessWidget {
  /// 创建Store，引用 FMState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<FMState>(
    appReducer,
    middleware: middleware,

    ///初始化数据
    initialState: new FMState(
        userInfo: fmwl_main, themeData: CommonUtils.getThemeData(GSYColors.primarySwatch), locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);

  double position = 0.0;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    height = MediaQuery.of(context).size.height - statusBarHeight;

  }
}

