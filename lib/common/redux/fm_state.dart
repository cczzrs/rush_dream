import 'package:flutter/material.dart';
import 'package:rush_dream/common/local/local_dao.dart';
import 'package:rush_dream/common/redux/middleware/epic.dart';
import 'package:rush_dream/common/redux/middleware/epic_middleware.dart';
import 'package:rush_dream/common/redux/middleware/epic_store.dart';
import 'package:rush_dream/common/redux/user_redux.dart';
import 'package:rush_dream/common/redux/theme_redux.dart';
import 'package:rush_dream/common/redux/locale_redux.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

/// 全局 Redux store 的对象，保存State数据
class FMState {
  /// App name "赴梦"
  String app_name = "赴梦";

  /// 用户信息
  Map userInfo;

  /// 主题数据
  ThemeData themeData;

  /// 语言
  Locale locale;

  /// 当前手机平台默认语言
  Locale platformLocale;

  /// 构造方法
  FMState({this.userInfo, this.themeData, this.locale});
}

/// 创建 Reducer
/// 源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
/// 我们自定义了 appReducer 用于创建 store
FMState appReducer(FMState state, action) {
  return FMState(
    /// 通过 UserReducer 将 FMState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),

    /// 通过 ThemeDataReducer 将 FMState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),

    /// 通过 LocaleReducer 将 FMState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
  );
}

final List<Middleware<FMState>> middleware = [
  EpicMiddleware<FMState>(UserInfoEpic()),
  UserInfoMiddleware(),
];

class UserInfoMiddleware implements MiddlewareClass<FMState> {
  @override
  void call(Store<FMState> store, dynamic action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      print("*********** UserInfoMiddleware *********** ");
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

class FetchUserAction {}

class UserInfoEpic implements EpicClass<FMState> {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<FMState> store) {
    return Observable(actions)
        // to UpdateUserAction actions
        .ofType(TypeToken<FetchUserAction>())
        // Don't start  until the 10ms
        .debounce(new Duration(milliseconds: 10))
        .switchMap((action) => _loadUserInfo());
  }

  // Use the async* function to make easier
  Stream<dynamic> _loadUserInfo() async* {
    print("*********** userInfoEpic _loadUserInfo ***********");
    var res = await Local.getUserInfoLocal();
    yield UpdateUserAction(res.data);
  }
}

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final UserReducer = combineReducers<Map>([
  TypedReducer<Map, UpdateUserAction>(_updateLoaded),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
Map _updateLoaded(Map user, action) {
  user = action.userInfo;
  return user;
}
