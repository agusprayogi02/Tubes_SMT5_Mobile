import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'result_helper.dart';

/// Abstract class of use case, that implements callable class in dart
/// See [https://dart.dev/guides/language/language-tour#callable-classes]
abstract class UseCase<Type, Params> {
  Future<bool> get hasInternetConnection async =>
      await Connectivity().checkConnectivity() != ConnectivityResult.none;

  Future<Result<Type>> call(Params params);
}

/// Default no params if the use case class does not need any param
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginateParams extends Equatable {
  final int page;
  final int limit;
  final String? filter;
  final String? search;

  const PaginateParams(
      {this.page = 1, this.limit = 30, this.filter, this.search});

  @override
  List<Object?> get props => [page, limit, filter];

  Map<String, dynamic> toJson() {
    return {
      'page[size]': limit,
      'page[number]': page,
      'sort': filter,
      'filter[is_active]': filter != null,
      'search': search,
    };
  }
}
