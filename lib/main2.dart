import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';
import 'package:rush_dream/common/config/localization/gsy_localizations_delegate.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/dataModel/show.dart';
import 'package:rush_dream/common/net/net_data_model.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/page/home.dart';
import 'package:rush_dream/page/home_page.dart';
import 'package:rush_dream/page/login_page.dart';
import 'package:rush_dream/page/welcome_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rush_dream/test/v.dart';
import 'package:redux/redux.dart';
import 'package:rush_dream/common/net/code.dart';

void main2() {
    runApp(new FlutterReduxApp());
//    debugPaintSizeEnabled = true;
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FlutterReduxApp extends StatelessWidget {
    /// 创建Store，引用 FMState 中的 appReducer 实现 Reducer 方法
    /// initialState 初始化 State
    final store = new Store<FMState>(
        appReducer,
        middleware: middleware,

        ///初始化数据
        initialState: new FMState(userInfo: fmwl_main, themeData: CommonUtils.getThemeData(GSYColors.primarySwatch), locale: Locale('zh', 'CH')),
    );
    
    FlutterReduxApp({Key key}) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
        /// 通过 StoreProvider 应用 store
        var home =  new StoreProvider(
            store: store,
            child: new StoreBuilder<FMState>(builder: (context, store) {

                return new MaterialApp(
                    //  MaterialApp 设置应用的名称、主题、语言、首页及路由列表等
                    title: store.state.app_name,
//                    title: "赴梦",
                    locale: store.state.locale,
                    supportedLocales: [store.state.locale],
                    theme: store.state.themeData,
//                    home: new HomePage(),
                    /// 多语言实现代理
//                    localizationsDelegates: [
//                        GlobalMaterialLocalizations.delegate,
//                        GlobalWidgetsLocalizations.delegate,
//                        FMLocalizationsDelegate.delegate,
//                    ],
                    localizationsDelegates: [
                        GlobalCupertinoLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        FMLocalizationsDelegate.delegate,
                    ],
                    /// 注册所有页面导航
                    routes: {
                        WelcomePage.sName: (context) {
                            store.state.platformLocale = Localizations.localeOf(context);
                            return WelcomePage();
                        },
                        HomePage.sName: (context) {
                            return new FMLocalizations(
                                child: new HomePage(),
                            );
                        },
                        MyHome.sName: (context) {
                            ///通过 Localizations.override 包裹一层，
                            return new FMLocalizations(
                                child: new MyHome(),
                            );
                        },
                        LoginPage.sName: (context) {
                            return new FMLocalizations(
                                child: new LoginPage(),
                            );
                        },
                    },
                );
            }),
        );
        return home;
//        return Container(
//            //白色背景
//            color: Colors.white,
//            //Dart语法中，?? 表示如果text为空，就返回尾号后的内容。
//            child: Text("这就是无状态DMEO"),
//        );
    }
}

/// 全局页面 base
class FMLocalizations extends StatefulWidget {
    final Widget child;
    
    FMLocalizations({Key key, this.child}) : super(key: key);
    
    @override
    State<FMLocalizations> createState() {
        return new _FMLocalizations();
    }
}

class _FMLocalizations extends State<FMLocalizations> {
    StreamSubscription stream;
    
    @override
    Widget build(BuildContext context) {
        return new StoreBuilder<FMState>(builder: (context, store) {
            ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
            return new Localizations.override(
                context: context,
                locale: store.state.locale,
                child: widget.child,
            );
        });
    }
    
    @override
    void initState() {
        super.initState();
        stream = Code.eventBus.on<HttpErrorEvent>().listen((event) {
            errorHandleFunction(event.code, event.message);
        });
    }
    
    @override
    void dispose() {
        super.dispose();
        if (stream != null) {
            stream.cancel();
            stream = null;
        }
    }
    
    errorHandleFunction(int code, message) {
        switch (code) {
            case Code.NETWORK_ERROR:
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error);
                break;
            case 401:
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_401);
                break;
            case 403:
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_403);
                break;
            case 404:
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_404);
                break;
            case Code.NETWORK_TIMEOUT:
            //超时
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_timeout);
                break;
            default:
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_unknown + " " + message);
                break;
        }
    }
}
