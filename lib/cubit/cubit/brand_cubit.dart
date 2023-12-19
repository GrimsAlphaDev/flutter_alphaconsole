import 'package:alphaconsole/cubit/state/brand_state.dart';
import 'package:alphaconsole/models/brand_model.dart';
import 'package:alphaconsole/services/api/brand_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandCubit extends Cubit<BrandState> {
  BrandCubit() : super(BrandInitial());

  final BrandService _brandService = BrandService();
  List<BrandModel> brands = [];
  String selectedBrand = "3";

  Future<void> getBrands() async {
    brands = [];
    emit(BrandLoadingState());
    try {
      final Response response = await _brandService.getBrands();
      for (var brand in response.data['data']) {
        brands.add(BrandModel.fromJson(brand));
      }

      // get the first brand set it to selected brand
      selectedBrand = brands[0].id;

      emit(BrandLoadedState(brand: brands, selectedBrand: selectedBrand));
    } catch (e) {
      emit(BrandErrorState(message: e.toString()));
    }
  }

  void selectBrand({id}) async {
    emit(BrandLoadingState());
    try {
      emit(BrandLoadedState(brand: brands, selectedBrand: id));
    } catch (e) {
      emit(BrandErrorState(message: e.toString()));
    }
  }

  void clearBrand() async {
    emit(BrandLoadingState());
    try {
      List<BrandModel> brandsDefault = [];
      emit(BrandLoadedState(brand: brandsDefault, selectedBrand: "3"));
    } catch (e) {
      emit(BrandErrorState(message: e.toString()));
    }
  }
}
