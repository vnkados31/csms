import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';


class QrScanner extends StatefulWidget {
  static const String routeName = '/qrscreen';
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  late bool sufficientCoupons = true;
  late bool alreadyScanned = false;

  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
              color: Colors.black,
              fontWeight:FontWeight.bold,
              letterSpacing: 1
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isFlashOn = !isFlashOn;
            });
            controller.toggleTorch();
          },
              icon: Icon(Icons.flash_on,color:isFlashOn?Colors.blue:Colors.grey,)
          ),
          IconButton(onPressed: (){
            setState(() {
              isFrontCamera = !isFrontCamera;
            });
            controller.switchCamera();
          },
              icon: Icon(Icons.camera_front,color:isFrontCamera? Colors.blue : Colors.grey,)
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
                child: Column(
                  children: [
                    Text("Place you Qr Code in the area",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight:FontWeight.bold,
                          letterSpacing: 1
                      ),),
                    SizedBox(height: 6,),
                    Text("Scanning will be started automatically",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54
                      ),
                    )
                  ],
                )
            ),
            Expanded(
              flex: 7,
              child: Container(
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: controller,
                        allowDuplicates: true,
                        onDetect: (barcode,args) async{
                          if(!isScanCompleted){
                            // String code = barcode.rawValue??'...';
                            // isScanCompleted = true;
                            // await _addUserInList(code);

                            // if(sufficientCoupons && !alreadyScanned){
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) =>
                            //           ResultScreen(
                            //             closeScreen: closeScreen, code: code,)));
                            // }
                            // else{
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) =>
                            //           NoSufficientCoupons(
                            //             closeScreen: closeScreen,)));
                            // }
                          }
                        },),
                      QRScannerOverlay(overlayColor: Colors.grey.withOpacity(0.5),borderColor: Colors.blue,)
                    ],
                  )
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // String currentUserUid = _user!.uid;
                  // //print(currentUserUid);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OfficeBoyList(id: currentUserUid),
                  //   ),
                  // );
                },
                icon: Icon(Icons.arrow_forward),
                label: const Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}