import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
void main() {
 // WidgetsFlutterBinding.ensureInitialized();   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then((_) {
    runApp(MyApp());
 // });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'SGS Upload Test',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.blue,
      //   // This makes the visual density adapt to the platform that you run
      //   // the app on. For desktop platforms, the controls will be smaller and
      //   // closer together (more dense) than on mobile platforms.
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //
      // ),
      home: MyHomePage(title: 'SGS Upload Test'),

    );
  }
}



// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Post{
  var filename;
}
class ImageAndCamera extends StatefulWidget {
  @override
  ImageAndCameraState createState() => ImageAndCameraState();
}


class ImageAndCameraState extends State<ImageAndCamera> { // 파일 경로 문자열은 카메라에서는 에러 발생했다. image_picker 모듈에서 File 객체 반환.
  File mPhoto;
  List<Asset> imageList = List<Asset>();
  final deptTextBox = TextEditingController();
  String fileName;
  String deptName = 'Gunpo' ;

  @override
  Widget build(BuildContext context) {
   // Widget photo = (mPhoto != null) ? Image.file(mPhoto) : Text('EMPTY');
    return Container(
      child: Column(
        children: <Widget>[
        // 버튼을 제외한 영역의 가운데 출력
          Expanded(
              // margin: const EdgeInsets.fromLTRB(5, 60, 5, 5),
           //    padding: new EdgeInsets.all(5),
           // // color: Colors.black,
            child:Center(
              child: TextField( decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "파일이름",
              ),
                controller: deptTextBox,
              ),
            ),
         //   margin: const EdgeInsets.only(top:60),
          ),
          Expanded(
            //alignment: Alignment.center,
            child:Center(
              child: mPhoto ==null ? null : Image.asset(mPhoto.path),
            )
          ),
          Row(
            children: <Widget>[
              // RaisedButton(
              //   child: Text('앨범'),
              //   onPressed: () => onPhoto(ImageSource.gallery),
              //   // 앨범에서 선택
              // ),

              FlatButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Image.asset('images/barcodeIcon.png',width: 100,height: 50),
                          padding:new EdgeInsets.all(5) ,
              ),
              FlatButton(
                // onTap: () => onPhoto(ImageSource.camera),
                // child : Icon(Icons.camera_alt,size: 60.0),
                 padding:  EdgeInsets.all(0),
                child: Icon(Icons.camera_alt,size: 60.0),
                 onPressed: () => onPhoto(ImageSource.camera),

                 // 사진 찍기
               ),
              // IconButton(
              //     icon: Icon(Icons.cloud_upload_outlined, size: 60.0,color: mPhoto == null ? Colors.grey : Colors.black),
              //     padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
              //     onPressed: mPhoto != null ? null : () {uploadButton();}
              // ),
              FlatButton(
                  child: Icon(Icons.cloud_upload_outlined, size: 60.0,color: mPhoto == null ? Colors.grey : Colors.black),
               //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                  onPressed: mPhoto == null ? null : () {uploadButton();}
              ),


              RaisedButton(
                child: Text('사진선택'),
                onPressed: imageList.length==0 ? () { getImage(); } : null
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            ),
    ],
    // 화면 하단에 배치
      mainAxisAlignment: MainAxisAlignment.center,
        ),
    );
    }

  // 앨범과 카메라 양쪽에서 호출.ImageSource.gallery와 ImageSource.camera 두 가지밖에 없다.
    void onPhoto(ImageSource source) async {
    // await 키워드 때문에 setState 안에서 호출할 수 없다.
      // pickImage 함수 외에 pickVideo 함수가 더 있다.
        File f = await ImagePicker.pickImage(source: source);
        if(f != null) {
          setState(() => mPhoto = f);
          // var request = http.MultipartRequest('POST',
          //     Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
          // request.files.add(
          //     await http.MultipartFile.fromPath(
          //       'file',
          //       f.path,
          //     )
          // );
          // //request.fields['fileKey']= "file";
          // request.fields['fileName'] = "TEST/Tqwer.jpg";
          // request.fields['dept'] = "TEST/T";

         // var res = await request.send();

          // log(" ${res.statusCode} ");
          // log(" ${res.stream.bytesToString()} ");
      }
    }

    void getImage() async{

      List<Asset> resultList = List<Asset>();
      try {
        resultList = await MultiImagePicker.pickImages(maxImages: 300, enableCamera: true);
      } catch (e)
      {
        log(e.toString());
      }
      if( resultList.length > 0)
      {
      setState(() {
        imageList = resultList;
      });

      // if(deptTextBox.text.trim().isNotEmpty)
      //   deptName = deptName +"/"+ deptTextBox.text;
      if(imageList.length > 0 ) {
          var now = new DateTime.now();
          String fileName1 = DateFormat('yyyy-MM-dd hh-mm-ss.').format(now);

          int fileCount = 0;
          for (Asset asset in imageList) {
            fileCount = fileCount + 1;
            // ByteData byteData = await asset.getByteData();
            // List<int> imageD = byteData.buffer.asUint8List();
            // var request = http.MultipartRequest('POST',
            //     Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
            // request.files.add(
            //     await http.MultipartFile.fromBytes(
            //         'file', imageD,
            //         filename: fileName1 + fileCount.toString().padLeft(3, '0') +
            //             ".png")
            // );
            // request.fields['dept'] = deptName;
            // var res = await request.send();
            String tempString = fileName1 + fileCount.toString().padLeft(3, '0') +".png";
            int res = await uploadImg(asset, tempString);

            if (res == 200) {
              Fluttertoast.showToast(msg: "전송완료 - " + fileCount.toString() + "/" +
                  imageList.length.toString(),
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP);
            }
            else {
              Fluttertoast.showToast(msg: "ERROR! 전송 실패",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP);
            }
            log(" ${res} ");
          }
          setState(() {
            imageList.clear();
          });
       }
      }
    }
  Future<void> scanBarcodeNormal() async {

    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.

      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", true, ScanMode.BARCODE);
        print(barcodeScanRes);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      fileName = barcodeScanRes;
    });
  }

  void uploadButton() async
  {
      String tempFileName = "";
      if(deptTextBox.text.trim().isEmpty)
        tempFileName = DateFormat('yyyy-MM-dd hh-mm-ss.').format(new DateTime.now());
      else
        tempFileName = deptTextBox.text;

      tempFileName = tempFileName + ".png";
       var request = http.MultipartRequest('POST',
           Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
       request.files.add(
           await http.MultipartFile.fromPath(
             'file',
             mPhoto.path,
             filename: tempFileName,
           )
       );
      request.fields['dept'] = deptName;

      var res = await request.send();

      log(" ${res.statusCode} ");
      log(" ${res.stream.bytesToString()} ");

      if (res.statusCode == 200) {
        Fluttertoast.showToast(msg: "전송완료 - " ,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP);
      }
      else {
        Fluttertoast.showToast(msg: "ERROR! 전송 실패",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP);
      }
  }

  Future<int> uploadImg (var asset, String fileName) async
  {
    ByteData byteData = await asset.getByteData();
    List<int> imageD = byteData.buffer.asUint8List();
    var request = http.MultipartRequest('POST',
        Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
    request.files.add(
        await http.MultipartFile.fromBytes(
        'file', imageD,
        filename: fileName)
    );
    request.fields['dept'] = deptName;
    var res = await request.send();
    return res.statusCode;
  }



}







// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //title bar!!
    //  appBar: null,
      body: ImageAndCamera(),
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Invoke "debug painting" (press "p" in the console, choose the
      //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //     // to see the wireframe for each widget.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //       FlatButton(
      //           onPressed: _testCr,
      //           child: Text('TTTT',style: TextStyle(fontSize: 15),)
      //       )
      //     ],
      //   ),
      // ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
