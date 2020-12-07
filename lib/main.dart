import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io' ;
import 'package:image/image.dart' as ImgCtl;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path/path.dart';
//import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
 // WidgetsFlutterBinding.ensureInitialized();   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then((_) {
    await Hive.initFlutter();
    await Hive.openBox('config');
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
//Camera ADd!
// IconData getCameraLensIcon(CameraLensDirection direction) {
//   switch (direction) {
//     case CameraLensDirection.back:
//       return Icons.camera_rear;
//     case CameraLensDirection.front:
//       return Icons.camera_front;
//     case CameraLensDirection.external:
//       return Icons.camera;
//   }
//   throw ArgumentError('Unknown lens direction');
// }

//
class ImageAndCamera extends StatefulWidget {
  @override
  ImageAndCameraState createState() => ImageAndCameraState();
}
class ImageAndCameraState extends State<ImageAndCamera> { // 파일 경로 문자열은 카메라에서는 에러 발생했다. image_picker 모듈에서 File 객체 반환.
  File mPhoto;
  List<Asset> imageList = List<Asset>();
  final deptTextBox = TextEditingController();
  String fileName;
  String deptName  ;
  String preFileName = '';
  Map<String, dynamic> setting;
  int fCount = 0;
  List<String> uploadNameList = List<String>();
  //var my_setting;


  @override
  void initState(){
    super.initState();

    // final my_setting1 = loadAsset();
    // my_setting1.then((value) => my_setting = value );
    // String news = await
    loadAsset();
  }

  void loadAsset() async {
    var my_setting = jsonDecode(await rootBundle.loadString('images/run.json'));
    setting = my_setting;


    setting['dept'] = Hive.box('config').get('dept') == null ? 'Other' : Hive.box('config').get('dept');
    setting['User'] = Hive.box('config').get('User') == null ? '' : Hive.box('config').get('User');
    setting['width'] = Hive.box('config').get('width') == null ? 0 : Hive.box('config').get('width');
    setting['height'] = Hive.box('config').get('height') == null ? 0 : Hive.box('config').get('height');
    setting['FileName'] = Hive.box('config').get('FileName') == null ? '' : Hive.box('config').get('FileName');

    deptTextBox.text = setting['FileName'];

  }

  
  @override
  Widget build(BuildContext context) {
   // Widget photo = (mPhoto != null) ? Image.file(mPhoto) : Text('EMPTY');
    return Container(
      // child : SingleChildScrollView(
      //   physics: NeverScrollableScrollPhysics(),

      child: Column(
        children: <Widget>[
        // 버튼을 제외한 영역의 가운데 출력
          Expanded(
              child:Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text('sdf'),

                      Flexible( //pre count
                        child: FlatButton(
                            child: Icon(Icons.keyboard_arrow_left),
                            //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                            onPressed: (){
                              if(fCount > 0) {
                                setState(() {
                                  fCount = fCount - 1;
                                });
                              }
                            }
                        ),
                      ),

                      Flexible( //next count
                        child: FlatButton(
                            child: Icon(Icons.keyboard_arrow_right),
                            //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                            onPressed: (){
                              setState(() {
                                fCount = fCount+1;
                              });
                             // deptTextBox.text.replaceAll('.'+temp, '.'+fCount.toString().padLeft(3, '0'));
                            }
                        ),
                      ),
                      Flexible(
                        child: FlatButton(
                            child: Icon(Icons.autorenew_rounded),
                            //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                            onPressed: (){
                              deptTextBox.text = setting['FileName'];
                            }
                        ),
                      ),
                      Flexible(
                         child: FlatButton(
                            child: Icon(Icons.settings),
                            //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SettingPage(setting) ));
                            }
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: TextField( decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:  'FileName' + (fCount ==0 ? '' : ' +.'+ fCount.toString().padLeft(3, '0')),
                    ),

                      controller: deptTextBox,
                    ),
                  ),
                ],

              )
          ),

         //  Expanded(
         //      // margin: const EdgeInsets.fromLTRB(5, 60, 5, 5),
         //   //    padding: new EdgeInsets.all(5),
         //    // color: Colors.black,
         //    child:Center(
         //      child: TextField( decoration: InputDecoration(
         //        border: OutlineInputBorder(),
         //        labelText:  'FileName',
         //        ),
         //
         //        controller: deptTextBox,
         //      ),
         //    ),
         // //   margin: const EdgeInsets.only(top:60),
         //  ),
          Expanded(
            //alignment: Alignment.center,
            child:Center(
              child: mPhoto == null ? null : Image.file(mPhoto,fit: BoxFit.contain,),
            )
          ),
          Row(
            children: <Widget>[
              // RaisedButton(
              //   child: Text('앨범'),
              //   onPressed: () => onPhoto(ImageSource.gallery),
              //   // 앨범에서 선택
              // ),
              Flexible(
                child:FlatButton(
                    onPressed: () => scanBarcodeNormal(),
                    child: Image.asset('images/barcodeIcon.png',width: 100,height: 50),
                            padding:new EdgeInsets.all(5) ,
                ),
              ),
              FlatButton(
                // onTap: () => onPhoto(ImageSource.camera),
                // child : Icon(Icons.camera_alt,size: 60.0),
                 padding:  EdgeInsets.all(0),
                child: Icon(Icons.camera_alt,size: 60.0),
                 onPressed: () => onPhoto(ImageSource.camera),

                 // 사진 찍기
               ),
              Flexible(
                child:FlatButton(
                    child: Icon(Icons.cloud_upload_outlined, size: 60.0,color: mPhoto == null ? Colors.grey : Colors.black),
                 //   padding: EdgeInsets.fromLTRB(0, 0, 50, 10),
                    onPressed: mPhoto == null ? null : () {uploadButton();}
                ),
              ),

              Flexible(
                child:RaisedButton(
                  child: Text('사진선택'),
                  onPressed: imageList.length==0 ? () { getImage(); } : null
              ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            ),

    ],
    // 화면 하단에 배치
      mainAxisAlignment: MainAxisAlignment.center,

      ),
      //////////
   //   )
    );
    }


  // 앨범과 카메라 양쪽에서 호출.ImageSource.gallery와 ImageSource.camera 두 가지밖에 없다.
    void onPhoto(ImageSource source) async {
    // await 키워드 때문에 setState 안에서 호출할 수 없다.
      // pickImage 함수 외에 pickVideo 함수가 더 있다.
      //  File f = await ImagePicker.pickImage(source: source,imageQuality: 80);
      File f = await ImagePicker.pickImage(source: source);

      // if(setting['width'] != 0 && setting['height'] != 0)
      //   //f = await ImagePicker.pickImage(source: source);
      //   f = await ImagePicker.pickImage(source: source,maxWidth: setting['width'],  maxHeight: setting['height']);
      // else
      //   f = await ImagePicker.pickImage(source: source);
      if(f != null) {
        setState(() => mPhoto = f
        );
        log('1234');
      }
    }

    void getImage() async{

      List<Asset> resultList = List<Asset>();
      try {
        resultList = await MultiImagePicker.pickImages(
            maxImages: 300,
            enableCamera: true,
            selectedAssets: imageList,
            cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
            materialOptions: MaterialOptions(
              actionBarColor: "#abcdef",
              actionBarTitle: "SELECT",
              allViewTitle: "All Photos",
              useDetailsView: false,
              selectCircleStrokeColor: "#000000", ),
        );
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
            String tempString = fileName1 + fileCount.toString().padLeft(3, '0') +".JPG";


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

    if (!mounted) return;

    setState(() {
      deptTextBox.text = barcodeScanRes;
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

      if(fCount > 0)
        tempFileName = tempFileName + '.' +fCount.toString().padLeft(3, '0') +  ".JPG";
      else
        tempFileName = tempFileName  +  ".JPG";

      if(setting['width'] != 0)
        await reSizeImg(mPhoto.path);

       var request = http.MultipartRequest('POST',
           Uri.parse("http://food-back.kr.sgs.com/board/receivephoto"));
       request.files.add(
           await http.MultipartFile.fromPath(
             'file',
             mPhoto.path,
             filename: tempFileName,
           )
       );
      request.fields['dept'] = setting['dept'];
      if(setting['User'].toString().isNotEmpty)
        request.fields['dept'] =  setting['dept'] + '/' + setting['User'];

      var res = await request.send();

      log(" ${res.statusCode} ");
      log(" ${res.stream.bytesToString()} ");

      if (res.statusCode == 200) {
        Fluttertoast.showToast(msg: "전송완료 - " ,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP);
        preFileName = deptTextBox.text + ' 전송';
      }
      else {
        Fluttertoast.showToast(msg: "ERROR! 전송 실패",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP);
        preFileName = deptTextBox.text + ' 오류';
      }
      setState(() {

      });
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
    request.fields['dept'] = setting['dept'];
    if(setting['User'].toString().isNotEmpty)
      request.fields['dept'] =  setting['dept'] + '/' + setting['User'] ;
    var res = await request.send();
    return res.statusCode;
  }

  void reSizeImg(String fPath) async{
    ImgCtl.Image img = ImgCtl.decodeImage(File(fPath).readAsBytesSync());
    ImgCtl.Image tempImg = ImgCtl.copyResize(img,  width: setting['width'] ,height: setting['height'] );
    new File(fPath).writeAsBytesSync(ImgCtl.encodeJpg(tempImg,quality: 80));
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

class SettingPage extends StatefulWidget{
  Map<String, dynamic> setting;
  int _select;
 // SettingPage({Key key, 'asd'}) : super(key: key);
  SettingPage(Map<String, dynamic> setting){
    this.setting = setting;
  }
  @override
  SettingPageState createState() => SettingPageState(setting);
}




class SettingPageState extends State<SettingPage>{
  Map<String, dynamic> setting;
  String deptTemp;
  int _selected;
  final FileName = TextEditingController();
  final UserName = TextEditingController();
  final imgWidth = TextEditingController();
  final imgHeight = TextEditingController();

  //List<dynamic> temp ;
  SettingPageState(Map<String, dynamic> setting){
    this.setting = setting;
    deptTemp = setting['dept'];
    FileName.text = setting['FileName'];
    UserName.text = setting['User'];
    imgWidth.text = setting['width'] == 0 ? '0' : setting['width'].toString();
    imgHeight.text = setting['height'] == 0 ? '0' : setting['height'].toString();
  }
  @override
  void dispose() {
    FileName.dispose();
    UserName.dispose();
    imgWidth.dispose();
    imgHeight.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    // if(setting != null)
     //  jsonWriteFile();
  }

  // void jsonWriteFile() async{
  //
  //   // final directory = (await getApplicationDocumentsDirectory()).path;
  //   // await File('$directory/images/run.json').writeAsString(jsonEncode(setting));
  //   log('???');
  //   final _filePath = await _localFile;
  //   _filePath.writeAsString(jsonEncode(setting));
  //   log(_filePath.path);
  //
  // }
  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }
  //
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/images');
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
            tiles: [
              ListTile(
                leading: Icon(Icons.device_unknown),
                title: Text('부서'),
                subtitle: Text(setting['dept']),

                onTap: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: new AlertDialog(

                      title: Text('부서'),
                      actions: [
                        FlatButton(
                            onPressed: (){
                              setState(() {
                                deptTemp = setting['dept'];
                                Hive.box('config').put('dept', deptTemp);
                                Navigator.pop(context);
                              });
                            },
                            child: Text('OK')

                        ),
                        FlatButton(
                            onPressed: (){
                              setState(() {
                                setting['dept'] = deptTemp;
                                Navigator.pop(context);
                              });
                            },
                            child: Text('CANCLE'),
                        )
                      ],
                      content: SingleChildScrollView(

                        child: new Material(
                          child: new MyDialogContent(countries: setting ),
                        )
                      )
                    )
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.person_rounded),
                title: Text('사용자'),
                subtitle: Text(setting['User'] == '' ? '사용안함' : setting['User']),

                onTap: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: new AlertDialog(
                        title: Text('유저(세부폴더)'),

                        actions: [
                          FlatButton(
                              onPressed: (){
                                setState(() {
                                  setting['User'] = UserName.text = UserName.text.trim();
                                  Hive.box('config').put('User', setting['User']);
                                  //setting['User'] = int.parse(UserName.text);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('OK')

                          ),
                          FlatButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Text('CANCLE'),
                          )
                        ],
                        content: TextField( decoration: InputDecoration(
                          //    border: OutlineInputBorder(),
                        ),
                          controller: UserName,
                        ),
                      )
                  );

                }
              ),
              ListTile(
                leading: Icon(Icons.device_unknown),
                title: Text('파일 기본 이'),
                subtitle: Text(setting['FileName']),
                onTap: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: new AlertDialog(
                          title: Text('파일 이름'),
                          actions: [
                            FlatButton(
                                onPressed: (){
                                  setState(() {
                                    setting['FileName'] = FileName.text = FileName.text.trim();
                                     Hive.box('config').put('FileName',  setting['FileName']);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('OK')

                            ),
                            FlatButton(
                              onPressed: (){
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('CANCLE'),
                            )
                          ],
                          content: TextField( decoration: InputDecoration(
                        //    border: OutlineInputBorder(),
                          ),
                            controller: FileName,
                          ),
                      )
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.collections_outlined),
                title: Text('사진 해상도 '),
                subtitle: Text(
                    setting['width'] == 0 ? '사용안함' : setting['width'].toString() + ' * ' + setting['height'].toString()
                ),
                onTap: (){
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('해상도 (0 입력시 사용 안함)'),
                          actions: [
                            FlatButton(
                                onPressed: (){
                                  setState(() {
                                    imgWidth.text = imgWidth.text.trim();
                                    if(imgWidth.text == '0')
                                      imgHeight.text = '0';
                                    else
                                      imgHeight.text = imgHeight.text.trim();
                                    setting['width'] = double.parse(imgWidth.text);
                                    setting['height'] = double.parse(imgHeight.text);
                                    Hive.box('config').put('width', setting['width']);
                                    Hive.box('config').put('height', setting['height']);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('OK')

                            ),
                            FlatButton(
                              onPressed: (){
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('CANCLE'),
                            )
                          ],
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller:  imgWidth,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text('     * '),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: imgHeight  ,
                            ),

                            )
                          ],
                        )
                      )
                  );
                }
              ),
            ]
        ).toList(),
      )
    );
  }


}


class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
    this.countries,
  }): super(key: key);

  Map<String, dynamic> countries;
  List<String> deptName = ['E&E','FOOD', 'FOOD Lab','Hard Line','Soft Line', 'Physical Lab','Kimhae' ,'Gunpo' ,'Other'];
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();

  // String ReturnDept(){
  //   return countries;
  // }
}
class _MyDialogContentState extends State<MyDialogContent> {
  int _selectedIndex;

  @override
  void initState(){
    super.initState();
    _selectedIndex = widget.deptName.indexOf(widget.countries['dept']);
  }

  _getContent(){
    if (widget.deptName.length == 0){
      return new Container();
    }

    return new Column(
        children: new List<RadioListTile<int>>.generate(
            widget.deptName.length,
                (int index){
              return new RadioListTile<int>(
                value: index,
                groupValue: _selectedIndex,
                title: new Text(widget.deptName[index]),
                onChanged: (int value) {
                  setState((){
                    _selectedIndex = value;
                    widget.countries['dept']  = widget.deptName[index];
                  });
                },
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
