// File định nghĩa các Events cho FilterBloc
import 'package:equatable/equatable.dart';
import '../models/todo_filter.dart';

// Base class cho FilterEvents
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

// Event: Thay đổi filter
class FilterChanged extends FilterEvent {
  final TodoFilter filter;

  const FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
