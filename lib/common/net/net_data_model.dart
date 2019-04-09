/// 网络结果模型
class ResultData {
  var data;
  bool result;
  int code;
  var headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}

/// 网络结果模型 - 异常结果
class HttpErrorEvent {
  final int code;
  final String message;

  HttpErrorEvent(this.code, this.message);
}

/// 网络结果数据模型
