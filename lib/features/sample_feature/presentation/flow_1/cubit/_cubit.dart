import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/sample_feature/domain/repositories/_repository.dart';
import 'package:meta/meta.dart';

part '_state.dart';

class SampleCubit extends Cubit<SampleState> {
  SampleCubit({required this.repository}) : super(SampleInitial());

  final Repository repository;
}
