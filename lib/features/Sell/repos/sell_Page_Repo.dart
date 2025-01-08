import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets/core/failure.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/core/type_def.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:uuid/uuid.dart';

final imagePickerRepoProvider = Provider((ref) => ImagesPicker(
    cFireStore: ref.read(fireStoreProvider),
    cPiker: ImagePicker(),
    cFile: [],
    cRef: ref));

List<XFile> images = [];

class ImagesPicker {
  final FirebaseFirestore fireStore;
  ImagePicker picker;
  List<XFile?> file;
  final Ref ref;

  ImagesPicker(
      {required FirebaseFirestore cFireStore,
      required ImagePicker cPiker,
      required List<XFile?> cFile,
      required Ref cRef})
      : fireStore = cFireStore,
        picker = cPiker,
        file = cFile,
        ref = cRef;

  Reference referenceRoot = FirebaseStorage.instance.ref();
  CollectionReference get uploads => fireStore.collection("sell");

  FutureEither<String> uploadImage(String petName, XFile image) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceDirImages = referenceRoot.child(petName); /////change
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      if (!kIsWeb) {
        await referenceImageToUpload.putFile(File(image.path));
      } else {
        Uint8List imageData = await XFile(image.path).readAsBytes();
        final metadata = fb.SettableMetadata(contentType: 'image/jpeg');
        await referenceImageToUpload.putData(imageData, metadata);
      }
      return right(await referenceImageToUpload.getDownloadURL());
    } catch (e) {
      return left(Failure("Error occured"));
    }
  }

  FutureEither<String> uploadData(UploadDataModel model) async {
    try {
      List<String> images = [];
      for (var i in ref.read(photosProvider).values) {
        final uploadedImage = await uploadImage(model.name, i); /////???
        uploadedImage.fold((l) => null, (r) => images.add(r));
      }
      model.images = images;
      model.breed = model.breed.replaceAll(" ", '');
      String uniqueId = model.id.isEmpty ? Uuid().v4() : model.id;

      await uploads.doc(uniqueId).set(model.toJson()); ////model.name not unique
      return right('Data Uploaded');
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> choose() async {
    try {
      file = await picker.pickMultiImage();
      if (file.isNotEmpty) {
        if (file.length > 4) {
          return left(Failure("You can select a maximum of 4 photos"));
        }

        for (var i in file) {
          String fileName = i!.path.split('/').last;
          final fileSize = await i.length();
          if (fileSize / 1000000 > 5) {
            return left(
                Failure("Size of the Image Can't be greater than 5 MB"));
          }
          ref.read(photosProvider.notifier).state[fileName] = i;
        }
        return right("Image Loaded");
      } else {
        return left(Failure("No Image Provided"));
      }
    } catch (e) {
      return left(Failure('Error Loading the Image'));
    }
  }

  Future<List<UploadDataModel>?> getSellList() async {
    try {
      List<UploadDataModel> userSellList = [];
      await uploads.get().then((document) {
        for (var sellData in document.docs) {
          final result =
              UploadDataModel.fromJson(sellData.data() as Map<String, dynamic>);

          if (result.uid ==
              ref.read(authControllerProvider.notifier).userData!.uid) {
            userSellList.add(result);
          }
        }
      });
      return userSellList;
    } catch (e) {
      return null;
    }
  }

  Future<UploadDataModel?> getItem(String petid) async {
    try {
      final result = await uploads.doc(petid).get();
      return UploadDataModel.fromJson(result.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// searching mechanism
  Future<List<UploadDataModel>?> getSearchItem(String name) async {
    List<UploadDataModel> results = [];
    try {
      await uploads.get().then((data) {
        for (var i in data.docs) {
          final result =
              UploadDataModel.fromJson(i.data() as Map<String, dynamic>);
          if (result.category.toLowerCase().startsWith(name) &&
              result.verified == true) {
            results.add(result);
          }
        }
      });
      return results;
    } catch (e) {
      return null;
    }
  }

  Future<List<BuyRequestModel>?> getAllBuyRequests() async {
    List<BuyRequestModel> requests = [];
    try {
      await fireStore.collection("buyRequest").get().then((value) {
        for (var i in value.docs) {
          final result = BuyRequestModel.fromJson(i.data());
          if (result.ownersUID ==
              ref.read(authControllerProvider.notifier).userData?.uid) {
            requests.add(result);
          }
        }
      });

      return requests;
    } catch (e) {
      return null;
    }
  }

  void removeItem(String name) async {
    await uploads.doc(name).delete();
    await fireStore.collection('buyRequest').get().then((value) async {
      for (var i in value.docs) {
        final result = BuyRequestModel.fromJson(i.data());
        if (result.petid.contains(name)) {
          await fireStore
              .collection('buyRequest')
              .doc(result.petid + result.ownersUID) //////change
              .delete();
        }
      }
    });
  }

  Future<void> removeItem2(String name) async {
    await fireStore.collection('buyRequest').get().then((value) async {
      // for (var i in value.docs) {
      //  final result = BuyRequestModel.fromJson(i.data());
      //  if (result.petid.contains(name)) {
      await fireStore
          .collection('buyRequest')
          .doc(name) //////change
          .delete();
      // }
      //}
    });
  }
}
