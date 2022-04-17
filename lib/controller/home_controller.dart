
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class HomeController extends GetxController{

  bool isLoadingData = false;
  bool isDownloading = false;
  TextEditingController urlController =  TextEditingController();

  var yt = YoutubeExplode();

  double progress = 0.0;


  dynamic video;

  void getVideo({required String url}) async {
    isLoadingData = true;
    update();

    try{

      var resultVideo = await yt.videos.get(url);
      video = resultVideo;

    }catch(e){
      print(e.toString());
    }finally{
      isLoadingData = false;
      update();
    }

  }


  void downloadAudio(BuildContext context)async{
    isDownloading = true;
    update();

    try{
      // get path
      Directory? appDownDir = await getDownloadsDirectory();
      String appDownPath =  appDownDir!.path;



      var manifest = await yt.videos.streamsClient.getManifest(video.id);

      var streamInfo = manifest.audioOnly.withHighestBitrate();

      var stream = yt.videos.streamsClient.get(streamInfo);
      // Open a file for writing.
      String fileName = video.title;
      fileName = fileName.split("/").join("_");

      var file = File("$appDownPath\\$fileName.${streamInfo.container}");
      var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);


      var size = streamInfo.size.totalBytes;
      var count = 0;

      await for (final data in stream) {
        // Keep track of the current downloaded data.
        count += data.length;
        // Calculate the current progress.
        double val = ((count / size));
        var msg = '${video.title} Downloaded to $appDownPath/$fileName';
        for (val; val == 1.0; val++) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
        progress = val;
        update();

        // Write to file.
        fileStream.add(data);
      }

      urlController.clear();
      video = null;
      update();

      fileStream.close();


    }catch(e){
      print(e.toString());
    }finally{
      isDownloading = false;
      update();
    }


  }


  void downloadVideo(BuildContext context)async{
    isDownloading = true;
    update();

    try{
      // get path
      Directory? appDownDir = await getDownloadsDirectory();
      String appDownPath =  appDownDir!.path;



      var manifest = await yt.videos.streamsClient.getManifest(video.id);


      var streams = manifest.muxed.bestQuality;
      var audio = streams;
      var audioStream = yt.videos.streamsClient.get(audio);

      //var streamInfo = manifest.audioOnly.withHighestBitrate();
      //var stream = yt.videos.streamsClient.get(streams);

      // Open a file for writing.
      String fileName = video.title;
      fileName = fileName.split("/").join("_");

      var file = File("$appDownPath\\$fileName.${streams.container}");
      var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);


      var size = streams.size.totalBytes;
      var count = 0;

      await for (final data in audioStream) {
        // Keep track of the current downloaded data.
        count += data.length;
        // Calculate the current progress.
        double val = ((count / size));
        var msg = '${video.title} Downloaded to $appDownPath/$fileName';
        for (val; val == 1.0; val++) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
        progress = val;
        update();

        // Write to file.
        fileStream.add(data);
      }

      urlController.clear();
      video = null;
      update();

      fileStream.close();


    }catch(e){
      print(e.toString());
    }finally{
      isDownloading = false;
      update();
    }


  }


}