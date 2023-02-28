import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NewScreen extends StatefulWidget {
  final List<dynamic>? courses;
  final String? id;
  final String? courseName;
  const NewScreen({Key? key, this.courses, this.id, this.courseName}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {

  List<String> listNameOfButton = ["Home","My Courses","Reviews","Blog","About Us"];

  getAllPaidCourses()
  async{
    await FirebaseFirestore.instance.collection("Users").doc().get().then((value) {
      print(value);
    });
  }

  @override
  void initState()
  {
    super.initState();
    getAllPaidCourses();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          color: Colors.purple,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  width<650?IconButton(onPressed: (){
                  },
                      icon: Icon(Icons.drag_handle,color: Colors.white,)):SizedBox(),
                  SizedBox(
                    height: 45,
                    child: Image.asset("assets/logo.png",alignment: Alignment.centerLeft,),
                  ),
                ],
              ),
              Row(
                  children: width>650?
                  List.generate(listNameOfButton.length, (index) {
                    return MaterialButton(
                      child: Text("${listNameOfButton[index]}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                      onPressed: (){

                      },
                    );
                  }):[
                    MaterialButton(
                    onPressed: (){},
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(child: Text("ST",style: TextStyle(height: 2.7,fontWeight: FontWeight.bold),)),
                    ),
                  )]
              )
            ],
          ),
        ),
      ),
      drawer: width<650?Drawer(
        width: 40,
        child: Column(
          children: [
            Text("Hii")
          ],
        ),
      ):null,
      body: LayoutBuilder(
        builder: (context,constraints){
          return Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   // image: AssetImage("assets/g8.png"),
              //   fit: BoxFit.fill
              // ),
              color: HexColor("#fef0ff"),
            ),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "welcome to ",style: TextStyle(fontWeight: FontWeight.w200,fontSize: width<850?width<430?25:30:55,color: Colors.black)),
                      TextSpan(text: "Data Science and \n Analytics Combo Course",style: TextStyle(fontSize: width<850?width<430?25:30:60,fontWeight: FontWeight.bold,color: Colors.black))
                    ]
                ),textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(8),
                  width: width<1700?width<1300?width<850?constraints.maxWidth-20:constraints.maxWidth-200:constraints.maxWidth-400:constraints.maxWidth-700,
                  height: width>700?240:195,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex:width<600?4:3,child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.asset("assets/logo.png"),
                      )),

                      Expanded(flex: width<600?6:4,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            // width>700?
                            MainAxisAlignment.spaceAround,
                            // :MainAxisAlignment.start,
                            children: [

                              // SizedBox(height: width>750?0:10,),
                              Container(
                                // margin: EdgeInsets.only(top: 3),
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text("Module 1",style: TextStyle(color: Colors.white,fontSize: 12),),
                              ),
                              // SizedBox(height: width>750?0:10,),
                              // SizedBox(height: 8,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Python for Data Science",style:
                                  TextStyle(height: 1,fontWeight: FontWeight.bold,fontSize: width>700?25:width<540?15:16),
                                    overflow: TextOverflow.ellipsis,maxLines: 2,),
                                  SizedBox(height: 15,),
                                  // SizedBox(height: width>750?0:10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Estimates learning time: 10 Hr",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:  width<540?width<420?11:13:14)),
                                          SizedBox(height: 3,),
                                          Text("Started on: Jan 01,2023",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:  width<540?width<420?11:13:14)),
                                          SizedBox(height: 3,),
                                          Text("Completed on: Jan 01,2023",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:  width<540?width<420?11:13:14)),
                                          SizedBox(height: 15,),
                                          SizedBox(
                                            width: width<400?160:190,
                                            child:
                                            MaterialButton(
                                              height: width>700?50:40,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              minWidth: width>700?100:60,
                                              onPressed: (){},
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 5,),
                                                  Expanded(
                                                      flex:1,
                                                      child:
                                                      Icon(Icons.play_arrow,color: Colors.white,size: width<200?2:null,)),
                                                  Expanded(
                                                      flex:3,
                                                      child:
                                                      Text("Resume learning",style: TextStyle(color: Colors.white,fontSize: width<500?10:null),overflow: TextOverflow.ellipsis,))
                                                ],
                                              ),color: Colors.purple,),
                                          )

                                        ],
                                      )),
                                      SizedBox(width: 5,),
                                      width<700?
                                      // Expanded(
                                      //   child:
                                      Column(
                                        mainAxisAlignment: width>700?MainAxisAlignment.center:MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 25,),
                                          CircularPercentIndicator(
                                            radius: width<700?width<500?20:30:70,
                                            lineWidth: width>700?10.0:4.0,
                                            animation: true,
                                            percent: 10/100,
                                            center: Text(
                                              10.toString() + "%",
                                              style: TextStyle(
                                                  fontSize: width>700?20.0:width<500?8:14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            backgroundColor: Colors.black12,
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: Colors.green,
                                          ),
                                          SizedBox(height: width<500?3:5,),
                                          Text("progress",style: TextStyle(fontSize: 7,fontWeight: FontWeight.bold),)
                                          // SizedBox(height: 15,),
                                          // Text("10%")
                                        ],
                                      )
                                      // ,
                                      // )
                                          :SizedBox(),
                                      SizedBox(width: 5,)
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )),
                      // SizedBox(width: 10,),
                      width>700?Expanded(flex:2,
                        // color: Colors.green,
                        child: Column(
                          mainAxisAlignment: width>700?MainAxisAlignment.center:MainAxisAlignment.end,
                          children: [
                            CircularPercentIndicator(
                              radius: width>700?70.0:40.0,
                              lineWidth: 10.0,
                              animation: true,
                              percent: 10/100,
                              center: Text(
                                10.toString() + "%",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              backgroundColor: Colors.black12,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.green,
                            ),
                            SizedBox(height: 15,),
                            Text("10%")
                          ],
                        ),):
                      SizedBox()
                      // Column(
                      //   mainAxisAlignment: width>700?MainAxisAlignment.center:MainAxisAlignment.end,
                      //   children: [
                      //     CircularPercentIndicator(
                      //       radius: width>700?70.0:30.0,
                      //       lineWidth: width>700?10.0:5.0,
                      //       animation: true,
                      //       percent: 10/100,
                      //       center: Text(
                      //         10.toString() + "%",
                      //         style: TextStyle(
                      //             fontSize: width>700?20.0:14,
                      //             fontWeight: FontWeight.w600,
                      //             color: Colors.black),
                      //       ),
                      //       backgroundColor: Colors.black12,
                      //       circularStrokeCap: CircularStrokeCap.round,
                      //       progressColor: Colors.green,
                      //     ),
                      //     SizedBox(height: 15,),
                      //     Text("10%")
                      //   ],
                      // ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


