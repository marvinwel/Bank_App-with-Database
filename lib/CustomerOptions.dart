import 'package:flutter/material.dart';
import 'NewEmployee.dart';
import 'NewBranch.dart';
import 'OpenAcountButton.dart';
import 'ApplyLoanButton.dart';
import 'PaymentButton.dart';

// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }

class CustomerOptions extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Customer"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OpenAccountButton(),
              SizedBox(width: 30,),
              ApplyLoanButton()
            ],),
          SizedBox(height: 50,),
          PaymentButton(),

        ],
      ),
    );
  }
}