import 'package:flutter/material.dart';
import 'NewCustomerButton.dart';
import 'AccountDetailsButton.dart';
import 'addAccount.dart';

// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }

class AccountOptions extends StatelessWidget{

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
              NewCutomerButton(),
              SizedBox(width: 30,),
              AccountDetailsButton()
            ],),
          SizedBox(height: 50,),
              addAccountButton(),

        ],
      ),
    );
  }
}