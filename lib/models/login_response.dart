class LoginResponse {
  LoginResponse({
    required this.message,
    required this.responseCode,
    required this.status,
  });

  late final String message;
  late final int responseCode;
  late final String status;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    responseCode = json['response_code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['response_code'] = responseCode;
    _data['status'] = status;
    return _data;
  }
}