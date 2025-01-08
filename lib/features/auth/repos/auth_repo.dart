import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/models/UploadDataModel.dart';

import '../../../core/failure.dart';
import '../../../core/providers.dart';
import '../../../core/type_def.dart';
import '../../../models/UserModel.dart';
import '../../Favourites/FavouriteModels/FavouriteModel.dart';

final authRepoProvider = Provider((ref) => AuthRepo(
      fStore: ref.read(fireStoreProvider), //FirebaseFirestore.instance
      fAuth: ref.read(authProvider), // FirebaseAuth.instance
    ));

class AuthRepo {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  AuthRepo({
    required FirebaseFirestore fStore,
    required FirebaseAuth fAuth,
  })  : fireStore = fStore,
        auth = fAuth;

  CollectionReference get _users => fireStore.collection("users");

  CollectionReference get requests => fireStore.collection("sell");

  CollectionReference get buyrequests => fireStore.collection("buyRequest");

  CollectionReference get categories => fireStore.collection('categories');

  CollectionReference get favourites => fireStore.collection('favourites');

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UploadDataModel?> getPetDetail(String name) async {
    try {
      final result = await requests.doc(name).get();
      return UploadDataModel.fromJson(result.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Stream<UploadDataModel?> getPetDetailStream(String na) {
    //////
    return requests.snapshots().map((event) {
      for (var i in event.docs) {
        final pet = UploadDataModel.fromJson(i.data() as Map<String, dynamic>);
        if (pet.id == na) {
          return pet;
        }
      }
      return null;
    });
  }

  FutureEither<UserModel> createWithEmail(
      String email, String password, String name, String role) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
          name: name,
          profilepic: "https://i.ibb.co/NWbm4N6/user.png",
          uid: credential.user!.uid,
          isAuthenticated: true,
          email: email,
          role: role);
      await _users.doc(userModel.uid).set(userModel.toMap());
      signOut();
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(getMessageFromErrorCode(e.code)));
    } catch (e) {
      return left(Failure("Something went wrong "));
    }
  }

  /// user login with email  FutureEither<T> = Future<Either<Failure, T>>;
  FutureEither<UserModel> signInWithEmail(
      String email, String password, String role) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? "",
            profilepic: userCredential.user!.photoURL ??
                "https://i.ibb.co/NWbm4N6/user.png",
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            email: userCredential.user!.email ?? "",
            role: '');
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserdata(userCredential.user!.uid).first;
        if (userModel.role != role) {
          signOut();
          return left(Failure("Can't login with ${userModel.role} account"));
        }
      }
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(getMessageFromErrorCode(e.code)));
    } catch (e) {
      return left(Failure("Something went wrong "));
    }
  }

  /// Function for the getting the user data present in the DB
  Stream<UserModel> getUserdata(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  /// for forgot Password
  FutureEither<String> forgotEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return right("Reset Link will be available.");
    } catch (e) {
      return left(Failure("Unable to send"));
    }
  }

  ///for admin for fetching all the requests
  Future<List<UploadDataModel>?> getAllRequests() async {
    List<UploadDataModel> requests = [];
    try {
      final result = await fireStore.collection('sell').get();
      for (var i in result.docs) {
        requests.add(UploadDataModel.fromJson(i.data()));
      }
      return requests;
    } catch (e) {
      return null;
    }
  }

  /// new stream Provider for the better working
  Stream<List<UploadDataModel>> getAllRequestsStream() {
    return requests.snapshots().map((event) {
      List<UploadDataModel> requests = [];

      for (var i in event.docs) {
        requests
            .add(UploadDataModel.fromJson(i.data() as Map<String, dynamic>));
      }
      return requests;
    });
  }

  Future<List<UploadDataModel>?> getAllBanners() async {
    List<UploadDataModel> requests = [];
    try {
      final result = await fireStore.collection('sell').get();
      for (var i in result.docs) {
        final parsedModel = UploadDataModel.fromJson(i.data());
        if (parsedModel.verified == true) {
          requests.add(parsedModel);
        }
      }
      return requests;
    } catch (e) {
      return null;
    }
  }

  Future<UploadDataModel?> getAnimal(String id) async {
    try {
      // Fetch the document with the specific ID from Firestore
      final docSnapshot = await fireStore.collection('sell').doc(id).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Parse the document data to the UploadDataModel
        final animalData = UploadDataModel.fromJson(docSnapshot.data()!);

        // Check if the animal is verified
        if (animalData.verified) {
          return animalData;
        } else {
          print('Animal is not verified.');
          return null;
        }
      } else {
        print('No animal found with the given ID.');
        return null;
      }
    } catch (e) {
      print('Error fetching animal: $e');
      return null;
    }
  }

  Future<List<UploadDataModel>?> getSuggestionBanners(String breed) async {
    List<UploadDataModel> requests = [];
    try {
      final result = await fireStore.collection('sell').get();
      for (var i in result.docs) {
        final parsedModel = UploadDataModel.fromJson(i.data());
        if (parsedModel.category.contains(breed)) {
          requests.add(parsedModel);
        }
      }
      return requests;
    } catch (e) {
      return null;
    }
  }

  FutureEither<String> addRequest(BuyRequestModel model) async {
    /* try {
      await buyrequests
          .doc(model.requesterUID + model.petid + model.ownersUID)
          .set(model.toJson());
      return right("Requested");
    } catch (e) {
      return left(Failure("Unable to request"));
    }*/
    final docRef = buyrequests.doc(model.petid + model.ownersUID);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Check if the document already exists
        final snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          // Document exists, you can choose to return a failure or handle it as needed
          throw Exception("Request already exists");
        }

        // Create a new request
        transaction.set(docRef, model.toJson());
      });

      return right("Requested");
    } catch (e) {
      // Handle different error cases accordingly
      if (e is FirebaseException) {
        return left(Failure("Unable to request"));
      } else {
        return left(Failure("Unable to request"));
      }
    }
  }

  Future<List<BuyRequestModel>> getAllOrders() async {
    List<BuyRequestModel> values = [];
    try {
      final result = await buyrequests.get();
      for (var i in result.docs) {
        values.add(BuyRequestModel.fromJson(i.data() as Map<String, dynamic>));
      }

      return values;
    } catch (e) {
      return [];
    }
  }

  FutureEither<bool> setFavourite(String petId, String userUid) async {
    try {
      await favourites.doc('$userUid $petId').set({'value': '$petId $userUid'});
      return right(true);
    } catch (e) {
      return left(Failure('Failed to add the item'));
    }
  }

  Future<List<Fmodel>> getFavourites() async {
    List<Fmodel> values = [];
    try {
      final result = await favourites.get();
      for (var i in result.docs) {
        final s = Fmodel.fromJson(i.data() as Map<String, dynamic>);
        values.add(s);
      }
      return values;
    } catch (e) {
      return [];
    }
  }

  FutureEither<bool> removeFavourite(String petId, String userUid) async {
    try {
      await favourites.doc('$userUid $petId').delete();
      return right(true);
    } catch (e) {
      return left(Failure('Failed to delete the item'));
    }
  }

  Future<bool> existsFavourite(String petId, String userUid) async {
    try {
      final result = await favourites.doc('$userUid $petId').get();
      if (result.data() != null) {
        return (true);
      } else {
        return (false);
      }
    } catch (e) {
      return false;
    }
  }

  // Future<List<String>>

  Future<bool> checkRequest(String document, requesterUID) async {
    try {
      /* final result =
          await fireStore.collection("buyRequest").doc(document).get();
      if (result.data() != null) {
       
        return false;
      } else {
        return true;
      }*/

      // If there are any documents in the query result, a request already exists
      try {
        // Query the collection for the specific document by its ID
        final documentSnapshot = await buyrequests.doc(document).get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // If it exists, check if the requesterUID matches
          final data = documentSnapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            // Check if the requesterUID is in the document
            return data['requesterUID'] !=
                requesterUID; // Return true if they are different
          }
        }
        // Document does not exist or UID does not match
        return true; // Allow a new request
      } catch (e) {
        // Handle any errors and allow a new request
        return true; // Return true to allow a new request in case of error
      }
    } catch (e) {
      return true;
    }
  }

  FutureEither<String> adminVerify(UploadDataModel data) async {
    if (data.rejected == false) {
      try {
        data.checked = true; //change here
        if (data.id != null && data.id!.isNotEmpty) {
          await requests.doc(data.id).set(data.toJson());

          /// here
          return right("Checked"); //do payment
        } else {
          return left(Failure("Document ID is missing"));
        }
      } on FirebaseException catch (e) {
        return left(Failure("Some error occured"));
      }
    } else {
      return left(Failure("Already Rejected"));
    }
  }

  FutureEither<String> paymentVerify(UploadDataModel data) async {
    if (data.rejected == false) {
      try {
        data.verified = true; //change here
        if (data.id != null && data.id!.isNotEmpty) {
          await requests.doc(data.id).set(data.toJson());

          /// here
          return right("Payment Successful"); //do payment
        } else {
          return left(Failure("Payment Unsuccessful"));
        }
      } on FirebaseException catch (e) {
        return left(Failure("Some error occured"));
      }
    } else {
      return left(Failure("Unsuccessful"));
    }
  }

  FutureEither<String> adminReject(UploadDataModel data, String reason) async {
    if (data.verified == false) {
      try {
        data.reason = reason;
        data.rejected = true;
        if (data.id != null && data.id!.isNotEmpty) {
          await requests.doc(data.id).set(data.toJson());

          return right("Request Rejected");
        } else {
          return left(Failure("Document ID is missing"));
        }
      } on FirebaseException catch (e) {
        return left(Failure("Some error occured"));
      }
    } else {
      return left(Failure('Already Verified'));
    }
  }

  FutureEither<String> updateStock(UploadDataModel data) async {
    // if (data.verified == true) {
    try {
      // Ensure that the document exists
      DocumentReference petRef = requests.doc(data.id);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the current document snapshot
        DocumentSnapshot snapshot = await transaction.get(petRef);

        if (!snapshot.exists) {
          return left(Failure("Pet does not exist"));
        }

        // Check the current stock
        int currentStock = snapshot['stock'];

        if (currentStock > 0) {
          // Decrement stock by 1
          transaction.update(petRef, {'stock': 0});
        } else {
          // Stock is 0, return an error
          return left(Failure("Out of stock"));
        }
      });

      return right("Order Placed");
    } on FirebaseException catch (e) {
      return left(Failure("Some error occurred: ${e.message}"));
    }
  }

  FutureEither<String> updateStock2(String id) async {
    // if (data.verified == true) {
    try {
      if (id.isNotEmpty) {
        // Update the 'sell' field with the new stock value
        await FirebaseFirestore.instance.collection('sell').doc(id).update({
          'stock': 1, // Update only the 'sell' field
        });

        return right("Request deleted");
      } else {
        return left(Failure("Request not deleted"));
      }
    } on FirebaseException catch (e) {
      return left(Failure("Some error occured"));
    }
    //  } else {
    //  return left(Failure('Already Verified'));
    //}
  }

  Future<UserModel?> getCustomerInfo(String uid) async {
    try {
      final result = await _users.doc(uid).get();
      return UserModel.fromMap(result.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  FutureEither<String> addCategory(Map<String, dynamic> params) async {
    try {
      await categories.doc(params['name']).set(params);
      return right("Category added");
    } catch (e) {
      return left(Failure("Unable to add"));
    }
  }

  Future<List<Map<String, dynamic>>?> getCategories() async {
    List<Map<String, dynamic>> catgories = [];
    try {
      await categories.get().then((animal) {
        for (var i in animal.docs) {
          catgories.add(i.data() as Map<String, dynamic>);
        }
      });
      return catgories;
    } catch (e) {
      return null;
    }
  }

  void deleteCategory(String name) async {
    await categories.doc(name).delete();
  }

  /// for signOut
  void signOut() {
    auth.signOut();
  }

  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "email-already-in-use":
        return "Email already used. Go to login page.";

      case "invalid-credential":
        return "Wrong email/password combination.";

      case "user-not-found":
        return "No user found with this email.";

      case "user-disabled":
        return "User disabled.";

      case "too-many-requests":
        return "Too many requests to log into this account.";

      case "network-request-failed":
        return "Server error, please try again later.";

      case "invalid-email":
        return "Email address is invalid.";

      default:
        return "Login failed. Please try again.";
    }
  }
}
