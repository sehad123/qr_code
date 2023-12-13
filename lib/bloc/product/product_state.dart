part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

// state / kondisi product
// 1. product awal -> kosong
// 2. product loading ...
// 3. product complete
final class ProductStateInitial extends ProductState {}

final class ProductStateLoading extends ProductState {}

final class ProductStateLoadingPDF extends ProductState {}

final class ProductStateComplete extends ProductState {}

final class ProductStateCompleteEdit extends ProductState {}

final class ProductStateCompleteDelete extends ProductState {}

final class ProductStateError extends ProductState {
  ProductStateError(this.message);
  final String message;
}
