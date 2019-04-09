import 'package:dio/dio.dart';
import 'package:rush_dream/common/config/config.dart';
import 'package:rush_dream/common/local/local_storage.dart';

/**
 * 授权 token 拦截器
 * Created by cczzrs
 * on 2019-4-9.
 */
/// 授权 token 拦截器
class TokenInterceptors extends InterceptorsWrapper {
  /// 后台系统采用 jwt 认证
  final String _JWT = "JWT ";
  String _token;

  /// 每次请求添加本地授权 token 到头部 headers
  @override
  onRequest(RequestOptions options) async {
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
      }
    }
    options.headers["Authorization"] = _JWT + _token;
    return options;
  }



  /// 保存授权 token 到本地
  @override
  onResponse(Response response) async{
    try {
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data["token"] != null) {
        _token = response.data["token"];
        await LocalStorage.save(Config.TOKEN_KEY, _token);
      }
    } catch (e) {
      print("++++TokenInterceptors.onResponse() ERROR:");
      print(e);
    }
    return response;
  }

  /// 清除授权 token
  clearAuthorization() {
    this._token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  /// 获取本地授权 token
  getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
        //提示输入账号密码
      return "";
    } else {
      this._token = token;
      return token;
    }
  }
}