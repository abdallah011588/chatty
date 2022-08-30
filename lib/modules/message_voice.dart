import 'package:chat/layout/cubit/cubit.dart';
import 'package:flutter/material.dart';
class voiceMessage extends StatefulWidget {
  const voiceMessage({Key? key}) : super(key: key);

  @override
  State<voiceMessage> createState() => _voiceMessageState();
}

class _voiceMessageState extends State<voiceMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     /* body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width:150 ,
                            child: Slider(
                              value: appCubit.get(context).voiceProgress(),
                              min: 0,
                              max:appCubit.get(context).audioPlayer.duration ==null? 0
                              :appCubit.get(context).audioPlayer.duration!.inSeconds.toDouble(),
                              onChanged: (v){
                                  appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
                              },
                            ),
                        ),
                         IconButton(
                             onPressed: (){
                               appCubit.get(context).playVoice();
                             },
                           icon: Icon( appCubit.get(context).audioPlayerIsPlaying? Icons.pause:Icons.play_arrow,),
                         ),
                      ],
                    ),
                  /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              appCubit.get(context).audioPlayer.position.inSeconds.toString(),
                            style: TextStyle(fontSize: 12),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            appCubit.get(context).audioPlayer.duration ==null? '0:0':appCubit.get(context).audioPlayer.duration!.inSeconds.toString(),

                            style: TextStyle(fontSize: 12),),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.teal[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width:150 ,
                          child: Slider(
                            value: appCubit.get(context).voiceProgress(),
                            min: 0,
                            max:appCubit.get(context).audioPlayer.duration ==null? 0
                                :appCubit.get(context).audioPlayer.duration!.inSeconds.toDouble(),
                            onChanged: (v){
                              appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            appCubit.get(context).playVoice();
                          },
                          icon: Icon( appCubit.get(context).audioPlayerIsPlaying? Icons.pause:Icons.play_arrow,),
                        ),
                      ],
                    ),
                   /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text('0:0',style: TextStyle(fontSize: 12),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text('0:29',style: TextStyle(fontSize: 12),),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}
