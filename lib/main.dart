import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? _imagem;

  Future _recuperarImagem(bool camera) async {
    XFile? imagemSelecionada;
    final ImagePicker _picker = ImagePicker();

    if (camera) {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.camera);
    } else {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = imagemSelecionada;
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = FirebaseStorage.instance.ref();
    Reference arquivo = pastaRaiz.child("fotos").child("foto1.jpg");
    arquivo.putFile(File(_imagem!.path));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar Imagem"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  _recuperarImagem(true);
                },
                child: Text("Camera")),
            TextButton(
                onPressed: () {
                  _recuperarImagem(false);
                },
                child: Text("Galeria")),
            _imagem == null ? Container() :
            Image.file(File(_imagem!.path)),
            TextButton(
                onPressed: () {
                _uploadImagem();
                },
                child: Text("Upload Storage"))
          ],
        ),
      ),
    );
  }
}
