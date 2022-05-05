import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Roflan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final appearDuration = const Duration(seconds: 1);
  String text = "Помоги оттереть";
  List<double> opacity = [1,1,1];
  int step = 0;
  bool isFinalStep = false;
  bool isEnd = false;


  double dist = 0;
  void scour(Offset d){
    dist+=d.distanceSquared;
    if(!isEnd&&dist>=1000){
      dist=0;
      for(int i=0;i<step+1;i++){
        if(!isFinalStep){
          var newOpacity=opacity[i]-(i==step?0.04:0.01);
          
          if(i==step&&newOpacity<=0.42){
            if(step+1!=opacity.length){
              step++;
            }else{
              isFinalStep=true;
            }
          }
          if(newOpacity>0){
            setState(() {
              opacity[i]=newOpacity;
            });
          }
        }else{
          var newOpacity=opacity[i]-0.01;

          if(i==step&&newOpacity<=0){
            setState(() {
              for(int j=0;j<step+1;j++){
                opacity[j]=0;
              }
              isEnd=true;
              text='Зачем черкаш трогал, дурак?';
            });
            break;
          }
          if(newOpacity>0){
            setState(() {
              opacity[i]=newOpacity;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait=MediaQuery.of(context).orientation==Orientation.portrait;
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: appearDuration,
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              width: isPortrait?MediaQuery.of(context).size.width*0.5:null,
              height: isPortrait?null:MediaQuery.of(context).size.height*0.6,
              child: GestureDetector(
                onPanUpdate: (d)=>scour(d.delta),
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: isEnd?1:0,
                      duration: appearDuration,
                      child: Image.asset("assets/images/roflan.png"),
                    ),
                    Opacity(
                      opacity: opacity[2],
                      child: Image.asset("assets/images/organism-point.png"),
                    ),
                    Opacity(
                      opacity: opacity[1],
                      child: Image.asset("assets/images/organism-point2.png"),
                    ),
                    Opacity(
                      opacity: opacity[0],
                      child: Image.asset("assets/images/organism-point3.png"),
                    ),
                    /*Image(
                      image: const AssetImage("assets/images/organism-point3.png"),
                      color: Color.fromRGBO(255,255,255,opacity[0]),
                      colorBlendMode: BlendMode.modulate
                    ),*/ ///not work on web
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}




