
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'base_de_datos/maindata.dart';
import 'base_de_datos/articulos.dart';
import 'productos.dart';

class scanner extends StatefulWidget {
  const scanner({super.key});

  @override
  State<scanner> createState() => _scannerState();
}

class _scannerState extends State<scanner> {

  // CONEXIÓN CON LA BASE DE DATOS

  MainData bd = MainData();

  String? mensaje;

  // CONTROL DE LA CÁMARA Y ML KIT

  CameraController? controlador;

  late final BarcodeScanner lectorCodigos;

  bool escanerActivo = false;
  bool inicializando = false;
  bool procesandoImagen = false;

  String? error;
  String? codigoDetectado;

  @override
  void initState() {
    super.initState();

    // Inicializamos ML Kit para leer códigos de productos.
    lectorCodigos = BarcodeScanner(
      formats: [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upca,
        BarcodeFormat.upce,
      ],
    );
  }

  // BUSCAR PRODUCTO EN SQLITE

  Future<void> buscarProducto(String codigo) async {
    try {
      // Consultamos SQLite utilizando el código detectado.
      Articulos? articulo =
          await bd.consultarArtiPorBarra(codigo);

      if (!mounted) return;

      // Comprobamos si encontramos el producto.
      if (articulo == null) {
        setState(() {
          mensaje =
              'Este producto no está registrado en NutriScan.';
        });

        return;
      }

      // Liberamos la cámara antes de navegar.
      final camara = controlador;
      controlador = null;

      await camara?.dispose();

      if (!mounted) return;

      setState(() {
        escanerActivo = false;
        inicializando = false;
      });

      // Abrimos la ficha nutricional del producto.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => productos(
            articulo: articulo,
          ),
        ),
      );

    } catch (e) {
      debugPrint('ERROR AL CONSULTAR EL PRODUCTO: $e');

      if (!mounted) return;

      setState(() {
        mensaje = 'No fue posible consultar el producto.';
      });
    }
  }

  // INICIAR CÁMARA Y LECTOR

  Future<void> iniciarCamara() async {
    setState(() {
      escanerActivo = true;
      inicializando = true;
      error = null;
      codigoDetectado = null;
      mensaje = null;
      procesandoImagen = false;
    });

    try {
      final camaras = await availableCameras();

      if (camaras.isEmpty) {
        throw Exception(
          'No se encontraron cámaras disponibles.',
        );
      }

      final camaraTrasera = camaras.firstWhere(
        (camara) =>
            camara.lensDirection == CameraLensDirection.back,
        orElse: () => camaras.first,
      );

      controlador = CameraController(
        camaraTrasera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await controlador!.initialize();

      if (!mounted) return;

      // Activamos la lectura continua de imágenes.
      await controlador!.startImageStream(procesarImagen);

      if (!mounted) return;

      setState(() {
        inicializando = false;
      });

    } catch (e) {
      debugPrint('ERROR AL INICIAR EL ESCÁNER: $e');

      if (!mounted) return;

      setState(() {
        error = e.toString();
        inicializando = false;
      });
    }
  }

  // CONVERTIR IMAGEN DE CÁMARA A INPUTIMAGE

  InputImage? convertirImagen(CameraImage imagen) {
    if (controlador == null) return null;

    final camara = controlador!.description;
    final sensorOrientation = camara.sensorOrientation;

    InputImageRotation? rotacion;

    if (Platform.isAndroid) {
      const orientaciones = {
        DeviceOrientation.portraitUp: 0,
        DeviceOrientation.landscapeLeft: 90,
        DeviceOrientation.portraitDown: 180,
        DeviceOrientation.landscapeRight: 270,
      };

      final compensacion =
          orientaciones[controlador!.value.deviceOrientation];

      if (compensacion == null) return null;

      final grados = camara.lensDirection ==
              CameraLensDirection.front
          ? (sensorOrientation + compensacion) % 360
          : (sensorOrientation - compensacion + 360) % 360;

      rotacion =
          InputImageRotationValue.fromRawValue(grados);

    } else if (Platform.isIOS) {
      rotacion =
          InputImageRotationValue.fromRawValue(
        sensorOrientation,
      );
    }

    if (rotacion == null) return null;

    // Comprobamos el formato de la imagen.
    final formato =
        InputImageFormatValue.fromRawValue(
      imagen.format.raw,
    );

    if (formato == null) return null;

    if (Platform.isAndroid &&
        formato != InputImageFormat.nv21) {
      return null;
    }

    if (Platform.isIOS &&
        formato != InputImageFormat.bgra8888) {
      return null;
    }

    // Estos formatos utilizan un solo plano.
    if (imagen.planes.length != 1) return null;

    final plano = imagen.planes.first;

    return InputImage.fromBytes(
      bytes: plano.bytes,
      metadata: InputImageMetadata(
        size: Size(
          imagen.width.toDouble(),
          imagen.height.toDouble(),
        ),
        rotation: rotacion,
        format: formato,
        bytesPerRow: plano.bytesPerRow,
      ),
    );
  }

  // PROCESAR IMÁGENES Y DETECTAR CÓDIGOS

  Future<void> procesarImagen(CameraImage imagen) async {
    // Evitamos procesar varias imágenes simultáneamente.
    if (procesandoImagen || codigoDetectado != null) return;

    procesandoImagen = true;

    try {
      final inputImage = convertirImagen(imagen);

      if (inputImage == null) return;

      final codigos =
          await lectorCodigos.processImage(inputImage);

      for (final codigo in codigos) {
        final valor = codigo.rawValue;

        if (valor != null && valor.isNotEmpty) {

          // Detenemos la lectura para evitar detecciones repetidas.
          final camara = controlador;

          if (camara != null &&
              camara.value.isStreamingImages) {
            await camara.stopImageStream();
          }

          if (!mounted) return;

          setState(() {
            codigoDetectado = valor;
          });

          debugPrint('CÓDIGO DETECTADO: $valor');

          // Buscamos el producto en SQLite.
          await buscarProducto(valor);

          break;
        }
      }

    } catch (e) {
      debugPrint('ERROR AL PROCESAR LA IMAGEN: $e');

    } finally {
      procesandoImagen = false;
    }
  }

  // DETENER CÁMARA Y ESCÁNER

  Future<void> detenerCamara() async {
    final camara = controlador;
    controlador = null;

    if (camara != null) {
      if (camara.value.isStreamingImages) {
        await camara.stopImageStream();
      }

      await camara.dispose();
    }

    if (!mounted) return;

    setState(() {
      escanerActivo = false;
      inicializando = false;
      procesandoImagen = false;
      codigoDetectado = null;
      mensaje = null;
      error = null;
    });
  }

  @override
  void dispose() {
    controlador?.dispose();
    lectorCodigos.close();
    super.dispose();
  }

  // INTERFAZ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner NutriScan'),
        centerTitle: true,
      ),

      body: !escanerActivo
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Escanea el código de barras de un producto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: iniciarCamara,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Escanear producto'),
                    ),
                  ],
                ),
              ),
            )

          : Column(
              children: [

                // VISTA DE LA CÁMARA

                Expanded(
                  child: inicializando
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )

                      : error != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No fue posible iniciar la cámara:\n$error',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )

                          : controlador != null &&
                                  controlador!.value.isInitialized
                              ? Center(
                                  child: AspectRatio(
                                    aspectRatio: controlador!
                                        .value.aspectRatio,
                                    child: CameraPreview(
                                      controlador!,
                                    ),
                                  ),
                                )

                              : const Center(
                                  child: Text(
                                    'Cámara no disponible',
                                  ),
                                ),
                ),

                // MENSAJE DE LA CONSULTA

                if (mensaje != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      mensaje!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )

                // CÓDIGO DETECTADO Y CONSULTA EN PROCESO

                else if (codigoDetectado != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '¡Código detectado!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        SelectableText(
                          codigoDetectado!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const CircularProgressIndicator(),

                        const SizedBox(height: 8),

                        const Text(
                          'Consultando producto...',
                        ),
                      ],
                    ),
                  ),

                // BOTÓN DE CANCELAR O VOLVER A ESCANEAR

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: detenerCamara,

                    icon: Icon(
                      mensaje != null
                          ? Icons.refresh
                          : Icons.close,
                    ),

                    label: Text(
                      mensaje != null
                          ? 'Volver a escanear'
                          : 'Cancelar escaneo',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
