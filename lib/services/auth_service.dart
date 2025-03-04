import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı kayıt işlemi
  Future<AppUser?> signUp(String email, String password, UserType userType,
      String name, int height, double weight) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      Map<String, dynamic> userBasicData = {
        'uid': uid,
        'email': email,
        'name': name,
        'userType': userType == UserType.client ? 'client' : 'dietitian',
      };
      print("Firestore'a kaydedilecek veri: $userBasicData");

      if (userType == UserType.client) {
        Client newUser = Client(
          uid: uid,
          name: name,
          email: email,
          height: height,
          weight: weight,
          allergies: [],
          diseases: [],
        );
        await _firestore.collection('clients').doc(uid).set(newUser.toMap());
      } else {
        Dietitian newUser = Dietitian(uid: uid, name: name, email: email, specialty: '');
        await _firestore.collection('dietitians').doc(uid).set(newUser.toMap());
      }

      await _firestore.collection('users').doc(uid).set(userBasicData);
      if (userCredential.user == null) {
        print("Kullanıcı oluşturulamadı, userCredential.user null döndü!");
        return null;
      }

      return AppUser.fromMap(userBasicData);
    } catch (e) {
      print("Kayıt hatası: $e");
      return null;
    }
  }

  // Kullanıcı giriş işlemi
  Future<AppUser?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) return null;

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      UserType userType = userData['userType'].toString().contains('dietitian')
          ? UserType.dietitian
          : UserType.client;

      if (userType == UserType.client) {
        DocumentSnapshot clientDoc =
        await _firestore.collection('clients').doc(uid).get();
        if (clientDoc.exists) {
          return AppUser.fromMap(clientDoc.data() as Map<String, dynamic>);
        }
      } else {
        DocumentSnapshot dietitianDoc =
        await _firestore.collection('dietitians').doc(uid).get();
        if (dietitianDoc.exists) {
          return AppUser.fromMap(dietitianDoc.data() as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      print("Giriş hatası: $e");
      return null;
    }
  }

  // Kullanıcı çıkış işlemi
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Şu an giriş yapan kullanıcıyı getir
  Future<AppUser?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return AppUser.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
