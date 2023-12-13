import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_code/models/product.dart';
import 'package:pdf/widgets.dart' as pw;
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        // menambahkan product
        var hasil = await firestore.collection("products").add({
          "name": event.name,
          "code": event.code,
          "qty": event.qty,
        });
        await firestore
            .collection("products")
            .doc(hasil.id)
            .update({"productId": hasil.id});
        emit(ProductStateComplete());
      } on FirebaseAuthException catch (e) {
        // Eror dari firebase auth
        emit(ProductStateError(e.message ?? "Tidak dapat menambah product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambahkkan product"));
      }
    });
    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        // Mengedit product ke firebase
        await firestore.collection("products").doc(event.productId).update({
          "name": event.name,
          "qty": event.qty,
        });

        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat mengedit  product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat mengedit  product"));
      }
    });
    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        // Menghapus product ke firebase
        await firestore.collection("products").doc(event.id).delete();
        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat menghapus product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menghapus product"));
      }
    });
    // export pdf
    on<ProductEventExportToPdf>((event, emit) async {
      try {
        emit(ProductStateLoadingPDF());
        // 1. Ambil semua data product dari firebase
        var querySnap = await firestore
            .collection("products")
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<Product> allProducts = [];

        for (var element in querySnap.docs) {
          Product product = element.data();
          allProducts.add(product);
        }
        // allProducts -> udah ada isinya, tergantung databasenya

        // 2. Bikin pdfnya (Create PDF) -> taro dimana ? -> penyimpanan local -> lokasi path
        final pdf = pw.Document();

        var data = await rootBundle
            .load("assets/fonts/opensans/OpenSans_Condensed-Bold.ttf");
        var myFont = pw.Font.ttf(data);
        var myStyle = pw.TextStyle(font: myFont);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return allProducts.map((product) {
                return pw.Container(
                  child: pw.Column(
                    children: [
                      pw.Text("Product Name: ${product.name}", style: myStyle),
                      pw.Text("Product Code: ${product.code}", style: myStyle),
                      pw.Text("Quantity: ${product.qty}", style: myStyle),
                      // Tambahkan detail produk lainnya sesuai kebutuhan
                    ],
                  ),
                );
              }).toList();
            },
          ),
        );

        // 3. Open pdfnya
        Uint8List bytes = await pdf.save();

        final pdfDir = await getApplicationDocumentsDirectory();
        File pdfFile = File("${pdfDir.path}/myproducts.pdf");

        // Write the PDF file to the storage
        await pdfFile.writeAsBytes(bytes);

        print(pdfFile.path);

        await OpenFile.open(pdfFile.path);

        print(pdfFile.path);

        emit(ProductStateComplete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat export product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat export product"));
      }
    });
  }
}
