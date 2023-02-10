import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/sample_feature/domain/entities/_.dart';

class SampleModel extends Sample {
  SampleModel({super.id});

  SampleModel.fromJson(Json json) {
    id = json['id'];
  }

  Json toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    return data;
  }
}
