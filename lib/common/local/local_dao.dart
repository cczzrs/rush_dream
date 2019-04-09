
import 'dart:async';
import 'dart:convert';
import 'package:rush_dream/common/config/config.dart';
import 'package:rush_dream/common/local/local_storage.dart';
import 'package:rush_dream/common/redux/user_redux.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:redux/redux.dart';

/// SharedPreferences 本地存储
class Local {
  
  /// 初始化本地用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }
    
    ///读取主题
    String themeIndex = await LocalStorage.get(Config.THEME_COLOR);
    if (themeIndex != null && themeIndex.length != 0) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }
    
    ///切换语言
    String localeIndex = await LocalStorage.get(Config.LOCALE);
    if (localeIndex != null && localeIndex.length != 0) {
      CommonUtils.changeLocale(store, int.parse(localeIndex));
    }
    
    return new DataResult(res.data, (res.result && (token != null)));
  }

  /// 获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      return new DataResult(userMap, true);
    } else {
      return new DataResult(null, false);
    }
  }

}

class DataResult {
  var data;
  bool result;
  Future next;
  
  DataResult(this.data, this.result, {this.next});
}
