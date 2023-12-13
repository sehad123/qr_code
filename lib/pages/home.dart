// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/bloc/auth/auth_bloc.dart';
import 'package:qr_code/bloc/product/product_bloc.dart';
import 'package:qr_code/routes/router.dart';
import 'package:gallery_saver/gallery_saver.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(20),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Add Product";
                icon = Icons.post_add_rounded;
                onTap = () => context.goNamed(Routes.addproduct);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_rounded;
                onTap = () => context.goNamed(Routes.products);
                break;
              case 2:
                title = "QR CODE ";
                icon = Icons.qr_code;
                onTap = () {
                  openCamera(context);
                };
                break;
              case 3:
                title = "Catalog";
                icon = Icons.document_scanner_outlined;
                onTap = () {
                  context.read<ProductBloc>().add(ProductEventExportToPdf());
                };
                break;
              default:
            }
            return Material(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (index == 3)
                          ? BlocConsumer<ProductBloc, ProductState>(
                              listener: (context, state) {
                                if (state is ProductStateError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is ProductStateLoadingPDF) {
                                  return const CircularProgressIndicator();
                                }
                                return SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      icon,
                                      size: 50,
                                    ));
                              },
                            )
                          : SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                icon,
                                size: 50,
                              )),
                      Text(title),
                    ],
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // proses login
          context.read<AuthBloc>().add(AuthEventLogout());
          context.goNamed(Routes.login);
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}

Future<void> openCamera(BuildContext context) async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraScreen(camera: firstCamera)),
  );
}

// ... kode lainnya ...

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  String? imagePath; // Menyimpan path dari gambar yang diambil

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      final image = await _controller.takePicture();
      setState(() {
        imagePath = image.path; // Mengupdate path gambar yang baru diambil
      });
    } catch (e) {
      print('Error saat mengambil gambar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: imagePath == null
          ? CameraPreview(_controller)
          : Center(
              child: Image.file(
                  File(imagePath!)), // Menampilkan gambar yang diambil
            ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 130, bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            _takePicture(); // Mengambil gambar saat tombol ditekan
          },
          child: Icon(
            Icons.camera,
            size: 50,
          ),
        ),
      ),
    );
  }
}
