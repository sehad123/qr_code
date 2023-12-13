import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/bloc/product/product_bloc.dart';
import 'package:qr_code/models/product.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.product, {super.key});

  final String id;

  final Product product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    qtyC.text = product.qty!.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("DETAIL PRODUCT"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nameC.text.length == 0 || qtyC.text.length == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("semua data wajib diisi"),
                  ),
                );
              } else {
                context.read<ProductBloc>().add(
                      ProductEventEditProduct(
                        productId: product.productId!,
                        name: nameC.text,
                        qty: int.tryParse(qtyC.text) ?? 0,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
                if (state is ProductStateCompleteEdit) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(state is ProductStateLoading
                    ? "LOADING..."
                    : "UPDATE PRODUCT");
              },
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                    ProductEventDeleteProduct(product.productId!),
                  );
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
                if (state is ProductStateCompleteDelete) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoading
                      ? "Loading..."
                      : "Delete Product",
                  style: TextStyle(
                    color: Colors.red.shade900,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
