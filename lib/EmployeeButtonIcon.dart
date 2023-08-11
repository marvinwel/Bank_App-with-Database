import 'package:flutter/material.dart';
import 'EmployeeOptions.dart';

class EmployeeButtonIcon extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeOption() ));
        },
    child: Column(
      children: [
        Ink.image(image: AssetImage('images/employees.png'),
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 6,),
        Text('Employees', style: TextStyle(fontSize: 32,color: Colors.blue),),
        SizedBox(height: 6,)
      ],
    )
    );


  }



}


