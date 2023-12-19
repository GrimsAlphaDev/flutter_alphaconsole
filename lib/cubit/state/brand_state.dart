import 'package:alphaconsole/models/brand_model.dart';
import 'package:equatable/equatable.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoadingState extends BrandState {}

class BrandLoadedState extends BrandState {
  final List<BrandModel> brand;
  final String selectedBrand;

  const BrandLoadedState({required this.brand, required this.selectedBrand});

  @override
  List<Object> get props => [brand];
}

class BrandErrorState extends BrandState {
  final String message;

  const BrandErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
