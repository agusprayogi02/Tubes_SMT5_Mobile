import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:penilaian/app/core/widgets/camera_overlay/camera_overlay_widget.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/ktm_model.dart';
import 'package:penilaian/app/data/services/local_services/flavor_local_services.dart';

part 'ktp_scan_state.dart';

class KtpScanCubit extends Cubit<KtpScanState> {
  KtpScanCubit() : super(KtpScanInitial());
  late String baseUrl;
  final local = FlavorLocalServicesImpl();

  Future<String> getStorage(String name) async {
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/photo/';
    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }
    return path + 8.generateRandomString + name;
  }

  Future<String> imageCrop(String imgPath, MediaQueryData media, OverlayModel model) async {
    var readImg = File(imgPath).readAsBytesSync();
    var decodedImage = await decodeImageFromList(readImg);
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;
    var isPortrait = media.orientation == Orientation.portrait;
    double width = isPortrait ? imgWidth * .9 : imgHeight * .5;
    double ratio = model.ratio as double;
    double height = width / ratio;
    double centerX = (isPortrait ? imgWidth : imgHeight) / 2;
    double centerY = (isPortrait ? imgHeight : imgWidth) / 2;

    String cropped = await getStorage("crop_${path.basename(imgPath)}");
    print("kooooo$cropped");
    img.Command cmd = img.Command()
      ..decodeImageFile(imgPath)
      ..copyCrop(
        x: (centerX - (width / 2)).toInt(),
        y: (centerY - (height / 2)).toInt(),
        width: width.toInt(),
        height: height.toInt(),
      )
      ..writeToFile(cropped);
    await cmd.executeThread();
    return cropped;
  }

  Future<void> scanKtp(String imagePath, OverlayModel model, MediaQueryData media,
      {bool crop = false}) async {
    emit(KtpScanLoading());
    String image = imagePath;
    if (crop) {
      image = await imageCrop(image, media, model);
    }
    final urlKu = await FirebaseFirestore.instance.collection('/base_url').doc('URLKU').get();
    baseUrl = urlKu.data()!['url'];
    await local.setBaseUrl(baseUrl);
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ),
    );
    try {
      final form = FormData.fromMap({'file': await MultipartFile.fromFile(image)});
      final rest = await dio.post(
        'upload',
        data: form,
      );
      if (rest.statusCode == 200) {
        final data = rest.data;
        final ktp = KtmModel.initial(data);
        emit(KtpScanLoaded(ktp));
        return;
      }
      emit(KtpScanError('Data tidak ditemukan!'));
    } on DioException catch (e) {
      if (e.response != null) {
        var err = e.response!.data['error'];
        if (e.response!.statusCode == 400) {
          emit(KtpScanError(err));
          return;
        }
        emit(KtpScanError(err));
      } else {
        emit(KtpScanError(e.toString()));
        return;
      }
    } catch (e) {
      emit(KtpScanError('Server Tidak Merespon!'));
    }
  }
}
//     String savePath = await getStorage(path.basename(image));
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         enableContours: true,
//         enableLandmarks: true,
//         enableClassification: true,
//         enableTracking: true,
//         performanceMode: FaceDetectorMode.accurate,
//       ),
//     );

//     final inputImage = InputImage.fromFilePath(image);

//     RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//     final List<String> dataText = [];
//     for (var item in recognizedText.blocks) {
//       for (var line in item.lines) {
//         dataText.add(line.text.replaceAll(':', '').trim());
//       }
//     }

//     for (var i = 0; i < dataText.length; i++) {
//       // print("--> ${dataText[i]} <--");
//       NIKModel r = await NIKValidator.instance.parse(nik: dataText[i]);
//       if (r.valid == true) {
//         final faces = await faceDetector.processImage(inputImage);
//         if (faces.isNotEmpty) {
//           final face = faces.first.boundingBox;
//           img.Command cmd = img.Command()
//             ..decodeImageFile(image)
//             ..copyCrop(
//                 x: face.left.toInt(),
//                 y: face.top.toInt(),
//                 width: face.width.toInt(),
//                 height: face.height.toInt())
//             ..writeToFile(savePath);

//           await cmd.executeThread();
//         } else {
//           emit(KtpScanError('Wajah tidak ditemukan'));
//           return;
//         }
//         final ktp = KtpModel.fromScan(r);
//         String name = dataText[i + 1].replaceAll(':', '');
//         emit(KtpScanLoaded(ktp.copyWith(name: () => name, photo: () => savePath)));
//         return;
//       }
//     }
//     textRecognizer.close();
//     faceDetector.close();

//     emit(KtpScanError('NIK tidak ditemukan'));
//   }
// }
