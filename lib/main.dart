import 'dart:convert';

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
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGS Upload Test',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
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

  @override
  Widget build(BuildContext context) {
   // Widget photo = (mPhoto != null) ? Image.file(mPhoto) : Text('EMPTY');


    return Container( child: Column( children: <Widget>[
      // 버튼을 제외한 영역의 가운데 출력
      Expanded(
        // child: Center(child: photo),
        child:Center(
          child: TextField( decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "사용자(폴더)",
          ),
            controller: deptTextBox,
          ),
        )
      ),
      Row(
        children: <Widget>[
          // RaisedButton(
          //   child: Text('앨범'),
          //   onPressed: () => onPhoto(ImageSource.gallery),
          //   // 앨범에서 선택
          // ),
          // RaisedButton(
          //   child: Text('카메라'),
          //   onPressed: () => onPhoto(ImageSource.camera),
          //   // 사진 찍기
          // ),
          RaisedButton(
            child: Text('사진선택'),
            onPressed: () { getImage(); }
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        ),
    ],
    // 화면 하단에 배치
      mainAxisAlignment: MainAxisAlignment.end,
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
          var request = http.MultipartRequest('POST',
              Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
          request.files.add(
              await http.MultipartFile.fromPath(
                'file',
                f.path,
              )
          );
          //request.fields['fileKey']= "file";
          request.fields['fileName'] = "TEST/Tqwer.jpg";
          request.fields['dept'] = "TEST/T";

          var res = await request.send();

          log(" ${res.statusCode} ");
          log(" ${res.stream.bytesToString()} ");
      }
    }

    void getImage() async{

      List<Asset> resultList = List<Asset>();
      List<File> files = [];
      resultList = await MultiImagePicker.pickImages(maxImages: 300, enableCamera: true);
      setState(() {
        imageList = resultList;
      });
      String deptName = "Gunpo";
      if(deptTextBox.text.trim().isNotEmpty)
        deptName = deptName +"/"+ deptTextBox.text;
      if(imageList.length > 0 ) {
        var now = new DateTime.now();
        String fileName1 = DateFormat('yyyy-MM-dd hh-mm-ss.').format(now);

        int fileCount = 0;
        for (Asset asset in imageList) {
          fileCount = fileCount +1;
          ByteData byteData = await asset.getByteData();
          List<int> imageD = byteData.buffer.asUint8List();
          var request = http.MultipartRequest('POST',
              Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
          request.files.add(
              await http.MultipartFile.fromBytes(
                  'file', imageD, filename: fileName1+ fileCount.toString().padLeft(3,'0')+".png"  )
          );

          request.fields['dept'] = deptName;
          var res = await request.send();

          if(res.statusCode==200)
            {
              Fluttertoast.showToast(msg: "전송완료 - "+ fileCount.toString()+"/"+imageList.length.toString(),
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP);
            }
          else
            {
              Fluttertoast.showToast(msg: "ERROR! 전송 실패",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP);
            }
          log(" ${res.statusCode} ");
        }
      }
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
