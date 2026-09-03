// File định nghĩa các Events cho SearchBloc
import 'package:equatable/equatable.dart';

// Base class cho SearchEvents
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

// Event: Thay đổi search query
// Sẽ sử dụng debounce transformer để tránh search quá nhiều lần
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Event: Clear search query
class SearchQueryCleared extends SearchEvent {
  const SearchQueryCleared();
}
