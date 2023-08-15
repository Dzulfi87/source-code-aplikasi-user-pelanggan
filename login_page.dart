import 'package:angkutan_sayur_user/component/func.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/presentation/pages/auth/daftar_page.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/auth/login_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/auth/login_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController txtNoHP = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext c) {
    return BlocProvider(create: (_)=> LoginBloc(),
    child: Scaffold(
      backgroundColor: ColorsConstant.green,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.35,
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    "PONCOKUSUMO PICKUP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Gabung bersama kami",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: MediaQuery.sizeOf(context).height * 0.65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Column(

                children: [
                  const SizedBox(height: 8,),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Masuk",
                      style: TextStyle(fontWeight: FontWeight.w600,color: ColorsConstant.green, fontSize: 20),
                    ),
                  ),
                  Form(
                    key: formKey,
                      child: Column(
                        children: [
                          AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16,),
                                const Text("No Telepon",),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: txtNoHP,
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber,
                                  ],
                                  // controller: controller.usernameTextController,
                                  // enabled: !controller.isLogging.value,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field ini harus diisi";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16,),
                                const Text("Kata Sandi",),
                                BlocBuilder<LoginBloc, LoginState>(
                                    builder:
                                        (context,state){
                                      if(state is ShowPasswordState){
                                        showPassword = true;
                                      }else if(state is HidePasswordState){
                                        showPassword = false;
                                      }
                                      return TextFormField(
                                        // controller: g.txtPassword,
                                        autofillHints: const [AutofillHints.password],
                                        controller: txtPassword,
                                        obscureText: !showPassword,
                                        // enabled: !controller.isLogging.value,
                                        decoration: InputDecoration(
                                          // hintText: "Masukkan Password",
                                          suffixIcon: InkWell(
                                              onTap: () {
                                              context.read<LoginBloc>().onMataTap(!showPassword);
                                              },
                                              child:  Icon(showPassword ?  Icons.visibility_off : Icons.visibility,
                                                color: Colors.black54,)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Field ini harus diisi";
                                          }
                                          return null;
                                        },
                                      );
                                        }
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: 24,),
                  SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<LoginBloc,LoginState>(
                        builder: (context, state){
                         return ElevatedButton(onPressed: (){
                           if(formKey.currentState!.validate()) {
                             context.read<LoginBloc>().onLogin(txtNoHP.text, txtPassword.text);
                           }
                          }, child: const Text("Masuk"));
                        },
                      )),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                        text: 'Belum punya akun?',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(text: ' Daftar',
                              style: const TextStyle(
                                  color: ColorsConstant.green),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Func.navigatorHelper.push(const DaftarPage());
                                }
                          )
                        ]
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),);
  }

  @override
  void initState() {
    super.initState();
    OneSignal.shared.getDeviceState().then((value) {
      print("mmamama ${value?.userId}");
    });
  }
}
