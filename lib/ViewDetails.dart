import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'Info.dart';




// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class ViewDetails extends StatefulWidget{

  State<ViewDetails> createState() => ViewDetailsState();
}


class ViewDetailsState extends State<ViewDetails>{


  String? _dropdownValue;
  String? name;
  String? SSN;
  String? City,Street,ESSN,accountNumber,balance,deposit,withdraw,overdraft,bankerType,loanAmount;
  String? date;
  String? phoneNumber;
  String? branch;
  String? accountType;
  bool info = false,loan=false,checkings=false;
  bool checkBoxValue = false;
  bool savings = false;
  List<String> list = <String>['Checkings', 'Savings','Loan','Credit Card '];

  List<String> CustName = [];
  int tableCount=0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loan=false;
    savings=false;
    checkings=false;
    //connect();
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

    var result = await pool.execute("Select Name from Customer");



    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        CustName.add(row.colAt(0).toString());
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




    //f checking account
    if(identical(accountType,"Checkings")){
      var result = await conn.execute("Select * from Customer as c, Held_Account as h, Checking as ch where c.SSN=h.CSSN and c.NAME=\'$name\' and ch.AccountNumber=h.AccountNumber");
      for (final row in result.rows) {
        print("database info here : \n");
        //print(row.assoc());

        setState(() {
          SSN=row.colAt(0);
          City=row.colAt(1);
          Street=row.colAt(3);
          ESSN=row.colAt(4);
          accountNumber=row.colAt(8);
          date=row.colAt(9);
          balance=row.colAt(10);
          overdraft=row.colAt(11);
          deposit=row.colAt(12);
          withdraw=row.colAt(13);
          info = true;
          checkings=true;
          print(row.colAt(0));
        });}

    }

    //f savings account
    else if(identical(accountType,"Savings")){
      var result = await conn.execute("Select * from Customer as c, Held_Account as h, Savings as ch where c.SSN=h.CSSN and c.NAME=\'$name\' and ch.AccountNumber=h.AccountNumber");
      for (final row in result.rows) {
        print("database info here : \n");
        //print(row.assoc());
        print(row.colAt(0));


        setState(() {
          SSN=row.colAt(0);
          City=row.colAt(1);
          Street=row.colAt(3);
          ESSN=row.colAt(4);
          accountNumber=row.colAt(8);
          date=row.colAt(9);
          balance=row.colAt(10);
          overdraft=row.colAt(11);  //used as interest
          deposit=row.colAt(12);
          withdraw=row.colAt(13);
          info = true;
          savings=true;
          print(row.colAt(0));
        });}
    }
    //f loan account
    else if(identical(accountType,"Loan")){
      var result = await conn.execute("Select * from Customer as c, Borrow as b, Loan as l where c.Name= \'$name\' and b.SSN= c.SSN and l.LoanNumber=b.LoanNumber");
      for (final row in result.rows) {
        print("database info here : \n");
        //print(row.assoc());
        print(row.colAt(0));

        setState(() {
          SSN=row.colAt(0);     //ssn
          City=row.colAt(1);     //city
          Street=row.colAt(3);  //street
          ESSN=row.colAt(4);  //essn
          bankerType = row.colAt(5);  //banker type 5
          accountNumber=row.colAt(8);   //loan number 8
          loanAmount = row.colAt(9);  //loan amount  9
          date=row.colAt(10);      //date payment 10
          balance=row.colAt(11);  //payment amount 11
          overdraft=row.colAt(12);  //branch name 12
          deposit=row.colAt(13);  //aproval date 13
          withdraw=row.colAt(14); //loan type 14
          info = true;
          loan=true;
          tableCount++;
        });}
    }
    //f credit card account
    else if(identical(accountType,"Credit Card")){
      var result = await conn.execute("Select * from Customer");
      for (final row in result.rows) {
        print("database info here : \n");
        //print(row.assoc());
        print(row.colAt(0));

        setState(() {
          CustName.add(row.colAt(0).toString());
          tableCount++;
        });}
    }
    else{
      setState(() {
        info=false;
      });
    }




    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        accountType = selectedValue;
      });
    }
  }

  Widget  calltext(){
    return DropdownMenuItem(child: Text("Branch"),value: "Branch",);
  }

  @override
  Widget build(BuildContext context){


    return Scaffold(
      appBar: AppBar(title: Text("Information"),),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100,top: 20),
                child: Text("Account Details",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Icon(Icons.search),),

                      hintText: "Enter Name",
                      //labelText: "Enter Name to search"
                  ),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter a name";
                    }else{
                      name = value;
                      return null;}
                  },),),


              SizedBox(height: 20,),

              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Account",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                  value: accountType,onChanged: (val) => setState(() => accountType = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),




              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tData Submitted!!')),);

                      InsertData();

                      print("Value : $name");
                      print("info : $info");
                      print("account : $accountType");
                      //info = true;



                    }
                  },
                  child: const Text('View Data'),
                ),
              ),



              info ? Info(SSN,City,name,Street,ESSN,accountNumber,date,balance,overdraft,deposit,withdraw,savings,bankerType,loanAmount,loan,checkings):Container(),


            ],
          ),
        ),
      ),
    );
  }
}