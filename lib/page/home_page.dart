import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_5/main.dart';
import 'package:flutter_5/model/media_source.dart';
import 'package:flutter_5/page/source_page.dart';
import 'package:flutter_5/widget/video_widget.dart';
import 'package:mime/mime.dart';
import 'dart:convert' show utf8;
import 'package:path/path.dart'as Path;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:export_video_frame/export_video_frame.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? fileMedia;
  MediaSource? source;
  String? prediction="";
  String prePrediction = "";

  final videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(0,-0.96),
                    child: Container(
                      height: 500,
                      child: fileMedia == null
                          ? Icon(Icons.photo, size: 120)
                          : (source == MediaSource.image
                              ? Image.file(fileMedia!)
                              : VideoWidget(fileMedia!)),
                    ),
                ),
                Align(
                  alignment: Alignment(0,0.8),
                  child:Text(
                    '$prediction',
                    style: TextStyle(fontSize: 21, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment(0,0.7),
                  child: Text(
                    'Predicted material is:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment(-0.8,1),
                  child:RaisedButton(
                    child: Text('Capture Image'),
                    shape: StadiumBorder(),
                    onPressed: () => capture(MediaSource.image),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment(0.8,1),
                  child:RaisedButton(
                    child: Text('Capture Video'),
                    shape: StadiumBorder(),
                    onPressed: () => capture(MediaSource.video),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );


  Future<String> upload(File imageFile) async {
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base =
        "https://v3-api.onrender.com";

    var uri = Uri.parse(base + '/analyze');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length, filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();

    await for(String value in response.stream.transform(utf8.decoder)){
      print(value);
      setState(() {
        prePrediction = value.substring(11,value.length-2);
      });
    }

    return prePrediction;
  }


  Future capture(MediaSource source) async{
    setState(() {
      this.source = source;
      this.fileMedia = null;
      this.prediction = "Analyzing...";
    });

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SourcePage(),
        settings: RouteSettings(
          arguments: source,
        ),
      ),
    );

    if (result == null) {
      return;
    } else {
      setState(() {
        fileMedia = result;
        prediction = "Analyzing...";
      });

      String? mimeStr = lookupMimeType(result.path);
      var fileType = mimeStr!.split('/');

      if(fileType[0] == "image"){
        await upload(result);
        setState(() {
          prediction = prePrediction;
        });
      }
      else if (fileType[0] == "video") {
        var info = await videoInfo.getVideoInfo(result.path);
        double? stopAt = info?.duration;
        double? current = 0;
        int framePerMs = 1000;
        var preds = new Map();

        while(current! < stopAt!) {
          var duration = Duration(milliseconds: current.round());
          var frame = await ExportVideoFrame.exportImageBySeconds(result, duration, 0);
          await upload(frame);

          if(preds.containsKey(prePrediction)){
            preds[prePrediction] = preds[prePrediction] + 1;
          }
          else{
            preds[prePrediction] = 1;
          }


          setState(() {
            prediction = "Analyzing... (Frame: " + ((current! / framePerMs).round() +1).toString() + " )" ;
          });

          current = (current+ framePerMs);
        }

        int max = -1;
        preds.forEach((k, v) => v > max ? max = v: max = max);

        setState(() {
          prediction = preds.keys.firstWhere(
                  (k) => preds[k] == max, orElse: () => null);
        });
      }
    }
  }
}
