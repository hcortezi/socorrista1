import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socorrista1/post.dart';

class ImageStoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> imageToStorage(Uint8List file) async {
    String id = const Uuid().v1();
    Reference ref =
        _storage.ref().child('imagens').child('$id.jpeg');
    UploadTask uploadTask = ref.putData(
      file
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadPost(String dados, String nome, String telefone, Uint8List file) async{
    String res = 'Ocorreu um erro';
    try {
      String photoURL =
      await imageToStorage(file);
      String postID = const Uuid().v1();
      Post post = Post(
        dados: dados,
        nome: nome,
        telefone: telefone,
        postID: postID,
        dataPublicada: DateTime.now(),
        postURL: photoURL,
      );
      _firestore.collection('emergencias').doc(postID).set(post.toJson(),);
      res = 'sucesso';
    } catch (err){
      res = err.toString();
    }
    return res;
  }
}