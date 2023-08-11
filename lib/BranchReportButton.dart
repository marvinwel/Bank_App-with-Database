import 'package:flutter/material.dart';
import 'BranchReport.dart';

class BranchReportButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BranchReport() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/report.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Branch Report', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


