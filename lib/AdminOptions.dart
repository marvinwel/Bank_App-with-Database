import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'viewData.dart';




// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class AdminOptions extends StatefulWidget{

  State<AdminOptions> createState() => AdminOptionsState();
}


class AdminOptionsState extends State<AdminOptions>{


  int tableCount=0;
  List<String> tableName = [];


  @override
   void initState() {
    super.initState();
    //this.nameScreen = "From initState";



    connect();

  }


  Future<void> connect() async{

    final pool = MySQLConnectionPool(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'password',
      maxConnections: 100,
      databaseName: 'Bank', // optional,
    );


    var result = await pool.execute("show tables");

    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));
      tableName.add(row.colAt(0).toString());
      setState(() {
        tableCount++;
      });}


    pool.close();

  }

  void getinfo(String tablename,BuildContext context) {

    Navigator.push(context, MaterialPageRoute(builder: (context) => viewData(tablename)));


  }









  Widget showTablesAsButtons(int i,BuildContext context){
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
      onPressed: () {
        getinfo(tableName.elementAt(i),context);
      },
      child:
      Text(tableName.elementAt(i), style: TextStyle(fontSize: 28,color: Colors.blue)),
    );
  }


  //display total tables
  Widget getTableLength(){

    return Container(
      margin: EdgeInsets.only(left: 20,bottom: 15),
      height: 20,
      width: double.infinity,
      child: Text("Total Tables: "+tableCount.toString(), style: TextStyle(fontSize: 18,color: Colors.blue),),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Admin"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Text('View Data', style: TextStyle(fontSize: 28,color: Colors.blue),),
            getTableLength(),


            for(int i =0;i<tableCount;i++)
            //get table name
              showTablesAsButtons(i,context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //NewEmployee(),
                SizedBox(width: 10,),
                //NewBranch()
              ],),

          ],
        ),
      ),
    );
  }
}