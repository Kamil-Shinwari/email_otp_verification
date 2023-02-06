import 'dart:convert';
import 'dart:developer';

import 'package:auth_email/auth_email.dart';
import 'package:email_otp/welcom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// This only use for testing purposes.
final authEmail = AuthEmail(
  appName: 'Auth Email Example',
  server: 'https://pub.vursin.com/auth-email/api',
  serverKey: 'ohYwh',
  isDebug: true,
);

void main() async {
  runApp(const MaterialApp(home: AuthEmailApp()));
}

class AuthEmailApp extends StatefulWidget {
  const AuthEmailApp({Key? key}) : super(key: key);

  @override
  State<AuthEmailApp> createState() => _AuthEmailAppState();
}

class _AuthEmailAppState extends State<AuthEmailApp> {
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();
  String sendOtpButton = 'Send OTP';
  String verifyOtpButton = 'Verify OTP';
  bool isverify=false;
    bool textBtnswitchState = false;

  bool isSent = false;
  String desEmailTextField = '';
  String verifyTextField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: username,
            decoration: InputDecoration(
                suffixIcon: TextButton(
                  onPressed: () {
                    // sendOTp();
                    // Login();
                    // newLogin();
                  },
                  child: Text("sent otp"),
                ),
                hintText: "user",
                border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: pass,
            decoration:
                InputDecoration(hintText: "pass", border: OutlineInputBorder()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Expanded(
                  child: ElevatedButton(
                    style: textBtnswitchState? ElevatedButton.styleFrom(backgroundColor: Colors.grey)
                    :ElevatedButton.styleFrom(
                 backgroundColor: Colors.green
               ),
               onPressed: (){
                newLogin();
               },
                      // onPressed:   textBtnswitchState? () async {
                      //   // verifyEmail();
                      //   newLogin();
                      // }:null,
                      child: Text("Login")),
                ),
              ],
            ),
          ),
          if (!isSent) ...[
            const Text('Input your client email:'),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: desEmailTextField,
              onChanged: (value) {
                desEmailTextField = value;
              },
              validator: (value) {
                if (!AuthEmail.isValidEmail(desEmailTextField)) {
                  return 'This email is not valid!';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
               
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        sendOtpButton = 'Sending OTP...';
                      });

                      final result =
                          await authEmail.sendOTP(email: desEmailTextField);

                      if (!result) {
                        setState(() {
                          sendOtpButton = 'Send OTP failed!';
                        });
                      }
                      setState(() {
                        isSent = result;
                      });
                    },
                    child: Text(sendOtpButton),
                  ),
                ),
                  SizedBox(
                  width: 10,
                ),
                
              ],
            )
          ] else ...[
            const Text('Input your OTP:'),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                verifyTextField = value;
                
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {

                final result = authEmail.verifyOTP(
                    email: desEmailTextField, otp: verifyTextField);

                if (result) {
                  setState(() {
                    verifyOtpButton = 'Verified OTP';
                    setState(() {
                      isverify=true;
                      textBtnswitchState = true;
                    });
                  });
                } else {
                  setState(() {
                    verifyOtpButton = 'Verify OTP failed!';
                  });
                }
              },
              child: Text(verifyOtpButton),
            )
          ]
        ],
      ),
    );
  }

  Future<void> Login() async {
    var response = await http.post(
        Uri.parse(
            "https://gentecbspro.com/MobileApp/CoreAPI/api/values/authenticate"),
        body: {"username": username.text, "password": pass.text});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data['token']);
      log(data['id']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("login")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("something wrong")));
    }
  }

  void newLogin() async{
    var url ='https://gentecbspro.com/MobileApp/CoreAPI/api/values/authenticate';
    // var data ={
    //   "username":username.text,
    //   "password":pass.text
    // };

    // double latitude = 37.4219983;
    // double longitude = -122.084;


    // var body = json.encode(data);

    String coordinatesJson = json.encode({
      "username":username.text,
      "password":pass.text
    });
    var urlParse = Uri.parse(url);
    http.Response response = await http.post(
      urlParse,
      body: coordinatesJson,
      headers: {
        "Content-Type":"application/json"
      }
    );
    var newd= jsonDecode(response.body);
    // log(newd['token']);
    log(response.body);
    if(response.statusCode==200){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("login Successfull")));
          log(newd["userID"]);
          Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(uid: newd['userID'],),));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("some error")));
    }
  }
}
