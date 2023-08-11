import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';


class viewData extends StatefulWidget{

  String tablename;
  viewData(this.tablename);
  State<viewData> createState() => viewDataState(this.tablename);
}

class viewDataState extends State<viewData>{


  String tablename;
  List<String> rowData = [];
  bool differentColor = false;

  viewDataState(this.tablename);

  






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }


  Future<void> connect() async {
    final pool = MySQLConnectionPool(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'password',
      maxConnections: 100,
      databaseName: 'Bank', // optional,
    );


    var result = await pool.execute("SELECT * FROM $tablename");

    for (final row in result.rows) {
      print("database info here : \n");
      print(row.assoc().length);
      //print(row.colAt(0));
      
      setState(() {
        rowData.add(row.assoc().toString());
      });
    }
  }

  Widget DisplayData(int i){

    differentColor ? differentColor=false : differentColor=true;
    return Container(
      margin: EdgeInsets.only(left: 20,top: 10),
      child: Text(rowData.elementAt(i),style: TextStyle(color: differentColor ? Colors.red : Colors.blue),),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Employee"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            for(int i = 0; i < rowData.length; i++)
              DisplayData(i),



          ],
        ),
      )

    );
  }
}