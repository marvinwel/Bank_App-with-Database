import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class LoanForm extends StatefulWidget{

  State<LoanForm> createState() => LoanFormState();
}


class LoanFormState extends State<LoanForm>{


  String? custName,loanAmount,loanNumber,loanType;
  String? name;
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  String? selectBranch;
  bool checkBoxValue = false;

  List<String> CustName = [];
  List<String> branchName = [];
  List<String> custSSn = [];
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

    //get customernames
    var result = await pool.execute("Select NAME,SSN from Customer order by NAME");

    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        CustName.add(row.colAt(0).toString());
        custSSn.add(row.colAt(1).toString());
      });}

    //get branch name
    var result1 = await pool.execute("select BranchName from Branch order by BranchName");
    for (final row in result1.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        branchName.add(row.colAt(0).toString());
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

    //connect to database
    await conn.connect();


    //get ssn from customer table
    int indexValue = CustName.indexOf(custName.toString());
    print("Index value : $indexValue");

    //insert into borrow table
    var stmt1 = await conn.prepare("INSERT INTO Borrow (SSN) VALUES (?)",);
    await stmt1.execute([custSSn.elementAt(indexValue)]);

    String ssn = custSSn.elementAt(indexValue);
    print("SSN : $ssn");
    //get loan number from borrow table
    var result1 = await conn.execute("select LoanNumber from Borrow where SSN = $ssn");
    for (final row in result1.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        loanNumber = row.colAt(0).toString();
      });}

    //insert into loan table
    var sqldate = DateTime.parse(date.toString());
    print("Date : $sqldate");

    print(int.parse(loanNumber.toString()));
    print(double.parse(loanAmount.toString()));
    print( date.toString());
    print(selectBranch.toString());
    print(loanType);
    var stmt = await conn.prepare("INSERT INTO Loan (LoanNumber,LoanAmount, PaymentAmount, BranchName,ApprovalDate,LoanType) VALUES (?, ?, ?, ?,?,?)",);
    await stmt.execute([int.parse(loanNumber.toString()) ,double.parse(loanAmount.toString()), 0.00,selectBranch.toString(),date.toString(),loanType]);

    


    


    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        custName = selectedValue;
      });
    }
  }

  Widget  calltext(){
    return DropdownMenuItem(child: Text("Branch"),value: "Branch",);
  }

  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = CustName.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();
    List<DropdownMenuItem> menuItemList1 = branchName.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Loan Form"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Loan Request!",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Customer",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: custName,onChanged: (val) => setState(() => custName = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Loan Amount"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter Loan Amount";
                    }else{
                      loanAmount = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Loan Type"),
                  validator: (value){
                    if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
                      return "Please Enter Loan Type";
                    }else{
                      loanType = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Date  YYYY-MM-DD"),
                  validator: (value){
                    if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
                      return "Please Enter Date";
                    }else{
                      date = value;
                      return null;}
                  },),),
              SizedBox(height: 15,),
              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Branch",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList1,
                  value: selectBranch,onChanged: (val) => setState(() => selectBranch = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              SizedBox(height: 20,),






              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tLoan Submitted!!')),

                      );

                      InsertData();

                      print("Value : $name");
                      print("Value : $SSN");
                      print("Value : $date");
                      print("Value : $phoneNumber");
                      print("Value : $custName");

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