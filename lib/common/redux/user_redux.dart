import 'package:rush_dream/common/local/local_dao.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/redux/middleware/epic.dart';
import 'package:rush_dream/common/redux/middleware/epic_store.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

/**
 * 用户相关Redux
 * Created by guoshuyu
 * Date: 2018-07-16
 */

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateMapAction 与 reducers 关联起来
final MapReducer = combineReducers<Map>([
  TypedReducer<Map, UpdateMapAction>(_updateLoaded),
]);

/// 如果有 UpdateMapAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
Map _updateLoaded(Map user, action) {
  user = action.userInfo;
  return user;
}

///定一个 UpdateMapAction ，用于发起 userInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateMapAction {
  final Map userInfo;

  UpdateMapAction(this.userInfo);
}

class FetchMapAction {
}


class MapInfoMiddleware implements MiddlewareClass<FMState> {

  @override
  void call(Store<FMState> store, dynamic action, NextDispatcher next) {
    if (action is UpdateMapAction) {
      print("*********** MapInfoMiddleware *********** ");
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

class MapInfoEpic implements EpicClass<FMState> {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<FMState> store) {
    return Observable(actions)
    // to UpdateMapAction actions
        .ofType(TypeToken<FetchMapAction>())
    // Don't start  until the 10ms
        .debounce(new Duration(milliseconds: 10))
        .switchMap((action) => _loadMapInfo());
  }

  // Use the async* function to make easier
  Stream<dynamic> _loadMapInfo() async* {
    print("*********** userInfoEpic _loadMapInfo ***********");
    var res = await Local.getUserInfoLocal();
    yield UpdateMapAction(res.data);
  }
}


///定一个 UpdateUserAction ，用于发起 userInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final Map userInfo;
  UpdateUserAction(this.userInfo);
}
