// File định nghĩa các States cho SearchBloc
import 'package:equatable/equatable.dart';

// SearchState đơn giản, chỉ chứa search query hiện tại
class SearchState extends Equatable {
  final String query;

  const SearchState(this.query);

  @override
  List<Object?> get props => [query];
}
