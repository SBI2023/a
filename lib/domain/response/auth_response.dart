class ResponseAuth {
  String status;
  String message;
  String? expDate;

  ResponseAuth(
      {required this.status, required this.message, required this.expDate});

  factory ResponseAuth.fromJson(Map<String, dynamic> json) {
    print("getCategoryModel.fromJson Ahaaaa    = $json");

    return ResponseAuth(
      status: json['status'],
      message: json['message'],
      expDate: json['exp_date'],
    );
  }
}


