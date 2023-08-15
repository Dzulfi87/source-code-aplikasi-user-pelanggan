import 'package:angkutan_sayur_user/data/constants/assets_constant.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/auth/register_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/auth/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtNoHP = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool showPassword = false;


  @override
  Widget build(BuildContext c) {
    return BlocProvider(
        create:(context)=> RegisterBloc(),
        child:Scaffold(
            appBar: AppBar(
              title: const Text("Daftar"),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset(AssetsConstant.imgRegister),
                          const SizedBox(height: 8,),
                          const Text("Lengkapi informasi berikut ini")
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text("Nama",),
                            TextFormField(
                              controller: txtNama,
                              autofillHints: const [
                                AutofillHints.name,
                                AutofillHints.nickname
                              ],
                              // controller: controller.usernameTextController,
                              // enabled: !controller.isLogging.value,
                              decoration: const InputDecoration(
                                  label: Text("Nama")
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field ini harus diisi";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: txtNoHP,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              keyboardType: TextInputType.phone,
                              // controller: controller.usernameTextController,
                              // enabled: !controller.isLogging.value,
                              decoration: const InputDecoration(
                                  label: Text("No Telepon")

                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field ini harus diisi";
                                }
                                return null;
                              },
                            ),
                            BlocBuilder<RegisterBloc,RegisterState>(
                                builder: (context,state){
                                  if(state is ShowPasswordState){
                                    showPassword = state.show;
                                  }
                                  return TextFormField(
                                    controller: txtPassword,
                                    autofillHints: const [AutofillHints.password],

                                    obscureText: !showPassword,
                                    // enabled: !controller.isLogging.value,
                                    decoration: InputDecoration(
                                      label: const Text("Password"),
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            context.read<RegisterBloc>().onMataTap(showPassword);
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
                            ),
                            const SizedBox(height: 16,)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16), topLeft: Radius.circular(16)),
              ),
              child: BottomAppBar(
                child: BlocBuilder<RegisterBloc,RegisterState>(
                  builder: (context,_)=> ElevatedButton(
                    onPressed: (){
                      context.read<RegisterBloc>().onRegister(txtNama.text, txtNoHP.text, txtPassword.text);
                    },
                    child: const Text("Daftar"),
                  ),
                ),
              ),
            )
        ) ,
    );
  }
}
