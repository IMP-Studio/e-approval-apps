import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;

typedef HandleDetection = Future<dynamic> Function(InputImage image);
enum Choice { view, delete }

Future<CameraDescription> getCamera(CameraLensDirection dir) async {
  return await availableCameras().then(
    (List<CameraDescription> cameras) => cameras.firstWhere(
      (CameraDescription camera) => camera.lensDirection == dir,
    ),
  );
}

Future<dynamic> detect(
    CameraImage image, HandleDetection handleDetection) async {
  try {
    CameraDescription description =
        await getCamera(CameraLensDirection.front);
    InputImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    InputImage inputImage = buildInputImage(image, rotation);

    return handleDetection(inputImage);
  } catch (e) {
    print({'detect': e});
  }
}

InputImageRotation rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return InputImageRotation.rotation0deg;
    case 90:
      return InputImageRotation.rotation90deg;
    case 180:
      return InputImageRotation.rotation180deg;
    default:
      assert(rotation == 270);
      return InputImageRotation.rotation270deg;
  }
}

InputImage buildInputImage(
  CameraImage image,
  InputImageRotation rotation,
) {
  InputImageMetadata metadata = InputImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: rotation,
    bytesPerRow: image.planes[0].bytesPerRow,
    format: InputImageFormat.nv21
  );

  return InputImage.fromBytes(
    bytes: concatenatePlanes(image.planes),
    metadata: metadata,
  );
}

Uint8List concatenatePlanes(List<Plane> planes) {
  int totalBytes = planes.map((Plane plane) => plane.bytes.length).reduce((value, element) => value + element);
  Uint8List concatenatedBytes = Uint8List(totalBytes);
  int offset = 0;
  
  for (Plane plane in planes) {
    concatenatedBytes.setRange(offset, offset + plane.bytes.length, plane.bytes);
    offset += plane.bytes.length;
  }
  
  return concatenatedBytes;
}

Float32List imageToByteListFloat32(
    imglib.Image image, int inputSize, double mean, double std) {
  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (imglib.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (imglib.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (imglib.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asFloat32List();
}

double euclideanDistance(List e1, List e2) {
  double sum = 0.0;
  for (int i = 0; i < e1.length; i++) {
    sum += pow((e1[i] - e2[i]), 2);
  }
  return sqrt(sum);
}
