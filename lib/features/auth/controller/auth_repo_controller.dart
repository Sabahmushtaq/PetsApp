import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/features/Home/screens/NavigationHome.dart';
import 'package:pets/features/admin/screens/admin_screen.dart';
import 'package:pets/features/auth/repos/auth_repo.dart';
import 'package:pets/features/auth/screens/Start_Page.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/models/UserModel.dart';

import '../../Favourites/FavouriteModels/FavouriteModel.dart';

final getAllFavouritesFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authControllerProvider.notifier).getFavourites());

final getAllOrdersFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authControllerProvider.notifier).getAllOrders());

final getPetDetailStreamProvider = StreamProvider.family((ref, String name) =>
    ref.watch(authControllerProvider.notifier).getPetDetailStream(name));

final getAllRequestsStreamProvider = StreamProvider(
    (ref) => ref.watch(authControllerProvider.notifier).getAllRequestsStream());

final getCustomerInfoFutureProvider = FutureProvider.autoDispose.family(
  (ref, String uid) =>
      ref.watch(authControllerProvider.notifier).getCustomerInfo(uid),
);

final getAllRequestsFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authControllerProvider.notifier).getAllRequests());

final getAllbannersFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authControllerProvider.notifier).getAllBanners());

final getSuggestionBannersFutureProvider = FutureProvider.autoDispose.family(
    (ref, String breed) =>
        ref.watch(authControllerProvider.notifier).getSuggestionBanners(breed));

final getAllCategoriesFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authControllerProvider.notifier).getCategories());

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(fAuthRepo: ref.watch(authRepoProvider)));

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChanges;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo authRepo; //ref.watch(authRepoProvider)

  AuthController({
    required AuthRepo fAuthRepo,
  })  : authRepo = fAuthRepo,
        super(false);

  UserModel? userData;

  Stream<User?> get authStateChanges => authRepo.authStateChanges;

  void register(
      {required String email,
      required String password,
      required String name,
      required String role,
      required BuildContext context}) async {
    state = true;
    final s = await authRepo.createWithEmail(email, password, name, role);

    s.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message, //Display correct error message
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 300),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      Navigator.pop(context);
      AnimatedSnackBar.material("User Created successfully",
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 300),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      state = false;
    });
  }

  void loginEmail(
      {required String email,
      required String password,
      required String role,
      required BuildContext context}) async {
    await FirebaseAuth.instance.currentUser?.reload();
    state = true;

    final login = await authRepo.signInWithEmail(email, password, role);
    login.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message, //Display correct error message
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 300),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      userData = r;

      Future.delayed(const Duration(seconds: 5), () async {
        /// enter the navigation code here
        role.contains('user')
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const NavigatorHome()),
                (route) => false)
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
                (route) => false);
        state = false;
      });
    });
  }

  Stream<UserModel> getDetails(String uid) {
    return authRepo.getUserdata(uid);
  }

  Future<List<Fmodel>> getFavourites() async {
    return await authRepo.getFavourites();
  }

  void forgotEmail(String email, BuildContext context) async {
    state = true;
    final s = await authRepo.forgotEmail(email);
    s.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 300),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      Navigator.pop(context);
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 300),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      state = false;
    });
  }

  /// forgot password from Profile Page
  void forgotEmailProfile(String email, BuildContext context) async {
    state = true;
    final s = await authRepo.forgotEmail(email);
    s.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      state = false;
    });
  }

  Future<List<UploadDataModel>?> getAllRequests() async {
    return await authRepo.getAllRequests();
  }

  Future<List<UploadDataModel>?> getAllBanners() async {
    return await authRepo.getAllBanners();
  }

  Future<UploadDataModel?> fetchPetData(String id) async {
    return await authRepo.getAnimal(id);
  }

  Future<List<UploadDataModel>?> getSuggestionBanners(String breed) async {
    return await authRepo.getSuggestionBanners(breed);
  }

  void adminVerify(
      UploadDataModel data, BuildContext context, WidgetRef ref) async {
    state = true;
    final result = await authRepo.adminVerify(data);
    state = false;
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      // ignore: unused_result
      ref.refresh(getAllRequestsFutureProvider.future);
      Navigator.pop(context);
    });
  }

  void adminReject(UploadDataModel data, BuildContext context, WidgetRef ref,
      String reason) async {
    state = true;
    final result = await authRepo.adminReject(data, reason);
    state = false;
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.error,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      // ignore: unused_result
      ref.refresh(getAllRequestsFutureProvider.future);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void updateStock(UploadDataModel data, BuildContext context) async {
    state = true;
    final result = await authRepo.updateStock(data);
    state = false;
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {});
  }

  Future<void> updateStock2(String id, BuildContext context) async {
    state = true;
    final result = await authRepo.updateStock2(id);
    state = false;
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    });
  }

  void paidVerify(
      UploadDataModel data, BuildContext context, WidgetRef ref) async {
    state = true;
    final result = await authRepo.paymentVerify(data);
    state = false;
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);

      // ignore: unused_result
      ref.refresh(getAllRequestsFutureProvider.future);
    });
  }

  void signOut(BuildContext context) {
    authRepo.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const StartPage()),
        (route) => false);
  }

  void addBuyRequest(BuyRequestModel model, BuildContext context) async {
    state = true;
    final result = await authRepo.addRequest(model);
    state = false;

    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);

      Navigator.pop(context);
    });
  }

  Future<bool> setFavourite(
      String petId, String userUid, BuildContext context) async {
    state = true;
    final result = await authRepo.setFavourite(petId, userUid);
    state = false;

    return result.fold((l) {
      state = false;
      AnimatedSnackBar.material('Failed to add',
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      return false;
    }, (r) {
      AnimatedSnackBar.material("Added to Favourites",
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      return true;
    });
  }

  Future<bool> removeFavourite(
      String petId, String userUid, BuildContext context) async {
    state = true;
    final result = await authRepo.removeFavourite(petId, userUid);
    state = false;

    return result.fold((l) {
      state = false;
      AnimatedSnackBar.material('Failed to Remove',
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      return false;
    }, (r) {
      AnimatedSnackBar.material("Removed from Favourites",
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
      return true;
    });
  }

  Future<bool> checkFavourite(String petId, String userUid) async {
    return await authRepo.existsFavourite(petId, userUid);
  }

  Future<UserModel?> getCustomerInfo(String uid) async {
    return await authRepo.getCustomerInfo(uid);
  }

  Future<List<BuyRequestModel>> getAllOrders() async {
    return await authRepo.getAllOrders();
  }

  Future<bool> checkRequest(String document, String uid) async {
    return await authRepo.checkRequest(document, uid);
  }

  void addCategory(
      Map<String, dynamic> params, BuildContext context, WidgetRef ref) async {
    state = true;
    final result = await authRepo.addCategory(params);
    result.fold((l) {
      state = false;
      AnimatedSnackBar.material(l.message,
              type: AnimatedSnackBarType.warning,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);
    }, (r) {
      AnimatedSnackBar.material(r.toString(),
              type: AnimatedSnackBarType.success,
              animationDuration: const Duration(milliseconds: 500),
              mobilePositionSettings:
                  const MobilePositionSettings(topOnAppearance: 100))
          .show(context);

      // ignore: unused_result
      ref.refresh(getAllCategoriesFutureProvider.future);
      Navigator.pop(context);
    });
  }

  Future<List<Map<String, dynamic>>?> getCategories() async {
    return await authRepo.getCategories();
  }

  void deleteCategory(String name, WidgetRef ref) {
    authRepo.deleteCategory(name);
    // ignore: unused_result
    ref.refresh(getAllCategoriesFutureProvider.future);
  }

  Future<UploadDataModel?> getPetDetail(String name) async {
    final result = await authRepo.getPetDetail(name);
    return result;
  }

  Stream<List<UploadDataModel>> getAllRequestsStream() {
    return authRepo.getAllRequestsStream();
  }

  Stream<UploadDataModel?> getPetDetailStream(String name) {
    return authRepo.getPetDetailStream(name);
  }
}
