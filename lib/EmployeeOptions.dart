import 'package:flutter/material.dart';
import 'NewEmployee.dart';
import 'NewBranch.dart';
import 'BranchReportButton.dart';
import 'UpdateEmpButton.dart';

// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }

class EmployeeOption extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Employees"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80,bottom: 100),
          child: Text("Employees Options",style: TextStyle(fontSize: 38,color: Colors.blue)),),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            NewEmployee(),
            SizedBox(width: 10,),
              UpdateEmpButton(),



          ],),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NewBranch(),
              SizedBox(width: 10,),
              BranchReportButton(),


            ],
          ),



        ],
      ),
    );
  }
}