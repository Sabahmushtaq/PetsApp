import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/features/Sell/repos/sell_Page_Repo.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/models/UploadDataModel.dart';

final getSearchItemFutureProvider = FutureProvider.family.autoDispose(
    (ref, String name) =>
        ref.watch(imagePickerControllerProvider.notifier).getItemSearch(name));

final getItemFutureProvider = FutureProvider.autoDispose.family(
    (ref, String name) =>
        ref.watch(imagePickerControllerProvider.notifier).getItem(name));

final getAllBuyRequestsFutureProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(imagePickerControllerProvider.notifier).getAllBuyRequests());

final futureSellDataProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(imagePickerControllerProvider.notifier).getSellData());

final imagePickerControllerProvider =
    StateNotifierProvider<ImagePickerController, bool>((ref) =>
        ImagePickerController(
            cImagePicker: ref.watch(imagePickerRepoProvider), cRef: ref));

class ImagePickerController extends StateNotifier<bool> {
  final ImagesPicker _imagePicker;
  final StateNotifierProviderRef ref;

  ImagePickerController(
      {required ImagesPicker cImagePicker,
      required StateNotifierProviderRef cRef})
      : _imagePicker = cImagePicker,
        ref = cRef,
        super(false);

  void picker(BuildContext context) async {
    state = true;
    final s = await _imagePicker.choose();
    state = false;
    s.fold((l) {
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.error,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r,
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    });
  }

  void uploadData(BuildContext context, UploadDataModel model) async {
    state = true;
    final result = await _imagePicker.uploadData(model);
    state = false;
    result.fold(
        (l) => AnimatedSnackBar.material(l.message,
                type: AnimatedSnackBarType.warning,
                animationDuration: const Duration(milliseconds: 500),
                mobilePositionSettings:
                    const MobilePositionSettings(topOnAppearance: 100))
            .show(context), (r) {
      AnimatedSnackBar.material(r,
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);

      // ignore: unused_result
      ref.refresh(futureSellDataProvider.future);
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pop(context);
      });
    });
  }

  Future<List<BuyRequestModel>?> getAllBuyRequests() async {
    return await _imagePicker.getAllBuyRequests();
  }

  Future<List<UploadDataModel>?> getSellData() async {
    return await _imagePicker.getSellList();
  }

  Future<UploadDataModel?> getItem(String petid) async {
    return await _imagePicker.getItem(petid);
  }

  Future<List<UploadDataModel>?> getItemSearch(String name) async {
    return await _imagePicker.getSearchItem(name);
  }

  void removeItem(String name, WidgetRef ref) {
    _imagePicker.removeItem(name);
    // ignore: unused_result
    ref.refresh(futureSellDataProvider.future);
  }

  Future<void> removeItem2(String name, WidgetRef ref) async {
    await _imagePicker.removeItem2(name);
    // ignore: unused_result
    ref.refresh(getAllBuyRequestsFutureProvider.future);
  }
}
