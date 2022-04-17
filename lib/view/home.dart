import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomeController controller = Get.put(HomeController());


  var formKey =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Video URL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              TextFormField(
                controller: controller.urlController,
                validator: (val){

                  if(val!.isEmpty){
                    return "Please Enter URL";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Youtube Video Url",
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 10.0,),
              MaterialButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    controller.getVideo(url: controller.urlController.text);
                  }
                },
                child:  const Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Colors.blue,
                minWidth: double.infinity,
                height: 50.0,
              ),
              const SizedBox(height: 10.0,),
              GetBuilder<HomeController>(
                builder: (_){
                  if(controller.isLoadingData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.video == null){
                    return Container();
                  }
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120.0,
                            height: 90.0,
                            color: Colors.grey,
                            child: Image.network("https://img.youtube.com/vi/${controller.video.id}/0.jpg"),
                          ),
                          const SizedBox(width: 10.0,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.video.title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0,),
                                Text(
                                  controller.video.url,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0,),
                                Text(
                                  "${controller.video.author}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      controller.isDownloading ? LinearProgressIndicator(
                        value: controller.progress,
                        minHeight: 10.0,
                        backgroundColor: Colors.grey[100],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ) : Row(
                        children: [
                          Expanded(child: MaterialButton(
                            onPressed: (){
                              controller.downloadVideo(context);
                            },
                            child:  const Text(
                              "Download Video",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Colors.blue,
                            minWidth: double.infinity,
                            height: 50.0,
                          ),),
                          const SizedBox(width: 10.0,),
                          Expanded(child: MaterialButton(
                            onPressed: (){
                              controller.downloadAudio(context);
                            },
                            child:  const Text(
                              "Download Audio",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Colors.green,
                            minWidth: double.infinity,
                            height: 50.0,
                          ),),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
