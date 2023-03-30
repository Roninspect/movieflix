import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants.dart';
import '../../../models/usermodel.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
      firestore: FirebaseFirestore.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChnages;
});

class AuthRepository {
  FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  CollectionReference get _user => _firestore.collection('users');

  Future<Either<String, UserModel>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final credential = GoogleAuthProvider.credential(
        accessToken: (await googleUser!.authentication).accessToken,
        idToken: (await googleUser.authentication).idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userDetails;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userDetails = UserModel(
          userName: userCredential.user!.displayName ?? 'no name',
          email: userCredential.user!.email ?? "no email",
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          profilePic: Constants.avatarDefault,
        );
        await _user.doc(userCredential.user!.uid).set(userDetails.toMap());
      } else {
        userDetails = await getUserData(userCredential.user!.uid).first;
      }
      return right(userDetails);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<User?> get authStateChnages =>
      FirebaseAuth.instance.authStateChanges();

  Stream<UserModel> getUserData(String uid) {
    return _user.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
