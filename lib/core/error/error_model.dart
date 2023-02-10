class ErrorModel {
  String? property;
  List<String>? errors;

  ErrorModel({this.property, this.errors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    List<String> errorList = [];
    if (json['errors'] != null) {
      json['errors'].forEach((v) => errorList.add(v));
    }
    property = json['property'];
    errors = errorList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['property'] = property;
    data['errors'] = errors;
    return data;
  }

  @override
  String toString() {
    return "ErrorModel(property: $property, error $errors)";
  }
}
