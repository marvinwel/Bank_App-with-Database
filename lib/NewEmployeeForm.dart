import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class NewEmployeeForm extends StatefulWidget{

  State<NewEmployeeForm> createState() => NewEmployeeFormState();
}


class NewEmployeeFormState extends State<NewEmployeeForm>{


  String? _dropdownValue;
  String? name;
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  bool checkBoxValue = false;

  List<String> branchName = [];
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

    var result = await pool.execute("Select BranchName from Branch");



    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        branchName.add(row.colAt(0).toString());
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

    var sqldate = DateTime.parse(date.toString());
    print("Date : $sqldate");
    var stmt = await conn.prepare(
      "INSERT INTO Employee (SSN, Name, Start_Date, Telephone, LengthOfEmployment,Bank_ID,ManagerSSN) VALUES (?, ?, ?, ?, ?, ?, ?)",
    );


    if(checkBoxValue ){
      await stmt.execute([SSN, name, sqldate, phoneNumber, 0, 1009, SSN]); //supervisor SSSN
    }else{
      await stmt.execute([SSN, name, sqldate, phoneNumber, 0, 1009, 36636381]); //another supervisor
    }



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

    List<DropdownMenuItem> menuItemList = branchName.map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Employee Form"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Welcome New Hire!",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Employee Name"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter corrrect name";
                    }else{
                      name = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Employee SSN (xxxxxxxxx)"),
                  validator: (value){
                    if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
                      return "Please Enter corrrect SSN Format";
                    }else{
                      SSN = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Start Date YYYY-MM-DD"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter corrrect Date Format";
                    }else{
                      date = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Phone Number xxx-xxx-xxxx"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter corrrect Date Format";
                    }else{
                      phoneNumber = value;
                      return null;}
                  },),),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Branch",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: _dropdownValue,onChanged: (val) => setState(() => _dropdownValue = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Checkbox(
                      value: checkBoxValue,
                      onChanged: (bool? value){

                        setState(() {
                          checkBoxValue = value!;
                        });},),),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 10),
                    child: Text("Manager", style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                  ),

                ],
              ),


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

                      print("Value : $name");
                      print("Value : $SSN");
                      print("Value : $date");
                      print("Value : $phoneNumber");
                      print("Value : $_dropdownValue");

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