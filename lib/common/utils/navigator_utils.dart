import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rush_dream/page/gsy_webview.dart';
import 'package:rush_dream/page/home.dart';
import 'package:rush_dream/page/home_page.dart';
import 'package:rush_dream/page/login_page.dart';
import 'package:rush_dream/page/notify_page.dart';
import 'package:rush_dream/page/photoview_page.dart';
import 'package:rush_dream/page/widget/home_drawer.dart';

/// 全局页面 API
class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
  
  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  /// 我的主页
  static goMyHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, MyHome.sName);
  }

  /// 我的主页 Drawer
  static goMyHomeDrawer(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomeDrawer.sName);
  }

  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }
  
  ///个人中心
//  static goPerson(BuildContext context, String userName) {
//    NavigatorRouter(context, new PersonPage(userName));
//  }
  
  ///仓库详情通知
  static Future goNotifyPage(BuildContext context) {
    return NavigatorRouter(context, new NotifyPage());
  }
  
  ///搜索
//  static Future goSearchPage(BuildContext context) {
//    return NavigatorRouter(context, new SearchPage());
//  }
  
  ///全屏Web页面
  static Future goGSYWebView(BuildContext context, String url, String title) {
    return NavigatorRouter(context, new GSYWebView(url, title));
  }
  
  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    NavigatorRouter(context, new PhotoViewPage(url));
  }
  
  ///用户配置
//  static gotoUserProfileInfo(BuildContext context) {
//    NavigatorRouter(context, new UserProfileInfo());
//  }
  
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }
}
