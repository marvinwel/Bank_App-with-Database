import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class BankForm extends StatefulWidget{

  State<BankForm> createState() => BankFormState();
}


class BankFormState extends State<BankForm>{


  String? _dropdownValue;
  String? Branchname;
  String? branchID;
  String? branchCity;
  String? branchAssest;
  String? branch;

  List<String> BankName = [];
  int BankID = 0;
  int tableCount=0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    var result = await pool.execute("Select NAME from Bank");



    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        BankName.add(row.colAt(0).toString());
        tableCount++;
      });}

    pool.close();
  }


  Future<void> InsertData() async{
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "Bank", // optional
    );

// actually connect to database
    await conn.connect();

    var result = await conn.execute("Select BANK_ID, NAME from Bank");
    for (final row in result.rows) {
      if(row.colAt(1).toString() == _dropdownValue){
          BankID = int.parse(row.colAt(0).toString());
      }
    }


    var stmt = await conn.prepare(
      "INSERT INTO Branch (BANK_ID, BranchName, City, Assest) VALUES (?, ?, ?, ?)",
    );


    await stmt.execute([BankID, Branchname, branchCity, branchAssest]);


    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  Widget  calltext(){
    return DropdownMenuItem(child: Text("Branch"),value: "Branch",);
  }

  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = BankName.map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Branch Form"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Open a New Branch!",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Branch Name"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter Branch name";
                    }else{
                      Branchname = value;
                      return null;}
                  },),),
              Container(margin: EdgeInsets.only(left: 30,top: 20),
                child: Text("Choose A Bank",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 15,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: _dropdownValue,onChanged: (val) => setState(() => _dropdownValue = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              // SizedBox(height: 5,),
              // Container(
              //   margin: EdgeInsets.only(left: 30,right: 100),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //         labelText: "Branch ID XXXX"),
              //     validator: (value){
              //       if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
              //         return "Please Enter corrrect SSN Format";
              //       }else{
              //         branchID = value;
              //         return null;}
              //     },),),
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "City"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter a City name";
                    }else{
                      branchCity = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Assest"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter Assest amount";
                    }else{
                      branchAssest = value;
                      return null;}
                  },),),



              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tData Submitted!!')),

                      );

                      InsertData();

                      print("Value : $branchID");
                      print("Value : $Branchname");
                      print("Value : $branchCity");
                      print("Value : $branchAssest");


                    }
                  },
                  child: const Text('Submit'),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}