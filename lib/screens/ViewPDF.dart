import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';

class ViewPDF extends StatefulWidget {
  final String pdfID;
  final String pdfURL;

  ViewPDF(this.pdfID, this.pdfURL);
  // const ViewPDF({Key? key}) : super(key: key);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  // final sampleUrl = resumeURL;

  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final file = File('${directory.path}/${widget.pdfID}.pdf');
    print(file.path);
    if (await file.exists()) {
      return file.path;
    }
    print(file.path);
    final response = await http.get(Uri.parse(widget.pdfURL));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 8,
              ),
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    size: SizeConfig.textMultiplier * 4,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    loadPdf();
                  },
                  icon: Icon(
                    Icons.replay,
                    size: SizeConfig.textMultiplier * 4,
                  ),
                ),
              ),
              if (pdfFlePath != null)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: PdfView(path: pdfFlePath!),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "PDF is not loaded, Refresh page or check internet connection",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
