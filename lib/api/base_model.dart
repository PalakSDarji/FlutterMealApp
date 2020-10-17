class BaseModel<T> {
  ServerError error;
  T data;
}

class ServerError {
  String msg;
  int statusCode;

  ServerError(int statusCode, String s);
}
