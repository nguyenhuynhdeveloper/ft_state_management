import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_ft_bloc/demo_cubit_bloc/bloc/person_state.dart';

PersonState initialState =
    PersonState(fullName: "nguyen van A", position: "tech", age: 0);

class PersonBloc extends Cubit<PersonState> {
  // PersonBloc(super.initialState);    // Cách viết 1 
  PersonBloc()
      : super(PersonState(fullName: "nguyen van A", position: "Tech", age: 0));   // Cách viết 2

  //Các hàm được định nghĩa sẵn để thay đổi state
  void changeFullName(params) {
    emit(state.copyWith(fullName: params));
  }

  void changePosition(params) {
    emit(state.copyWith(position: params));
  }

  void changeAge(params) {
    emit(state.copyWith(age: params));
  }
}
