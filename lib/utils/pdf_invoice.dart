import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html; // chỉ dùng cho web

import '../providers/cart_provider.dart';

Future<pw.Document> generateInvoice(CartProvider cart) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Purchase invoice",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Name', 'Quantity', 'Price', 'Total'],
              data: cart.items.values.map((item) {
                return [
                  item.product.name,
                  item.quantity.toString(),
                  "${item.product.price.toStringAsFixed(2)} vnd",
                  "${(item.quantity * item.product.price).toStringAsFixed(2)} vnd",
                ];
              }).toList(),
            ),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total: ${cart.total.toStringAsFixed(2)} vnd",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}

Future<void> exportPdf(pw.Document pdf) async {
  final bytes = await pdf.save();

  if (kIsWeb) {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'invoice.pdf';

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  } else {
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }
}
