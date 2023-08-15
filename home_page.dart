import 'package:angkutan_sayur_user/data/constants/assets_constant.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/domain/entities/alamat_entity.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/home/home_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/home/home_state.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/service/current_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtAsal = TextEditingController();
  TextEditingController txtTujuan = TextEditingController();
  TextEditingController txtNamaBarang = TextEditingController();
  TextEditingController txtCatatanAlamat = TextEditingController();
  TextEditingController txtBerat = TextEditingController();

  var formKey = GlobalKey<FormState>();

  late AlamatEntity tujuan;
  late AlamatEntity asal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CurrentLocationBloc>().onLoadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 100),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorsConstant.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
              ),
              child: Image.asset(AssetsConstant.imgWorld),
            ),
            Positioned.fill(
              top: MediaQuery.sizeOf(context).height * 0.12,
              // alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PONCOKUSUMO PICKUP",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Instant Pickup",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Divider(
                        thickness: 4,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Card(
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Asal"),
                                BlocConsumer<HomeBloc, HomeState>(
                                    builder: (context, state) => InkWell(
                                          onTap: () => context
                                              .read<HomeBloc>()
                                              .onAsalTap(context
                                                  .read<CurrentLocationBloc>()),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxHeight: 100),
                                            child: TextFormField(
                                              controller: txtAsal,
                                              maxLines: null,
                                              onTap: () {
                                                print('sadasdasd');
                                              },
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              enabled: false,
                                              decoration: const InputDecoration(
                                                hintText: "Pilih asal",
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Field ini harus diisi";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                    listener: (c, s) {
                                      if (s is AsalChangedState) {
                                        txtAsal.text = s.asalEntity.alamat;
                                        asal = s.asalEntity;
                                      }
                                    }),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text("Tujuan"),
                                BlocConsumer<HomeBloc, HomeState>(
                                  listener: (context, state) {
                                    if (state is TujuanChangedState) {
                                      txtTujuan.text =
                                          state.tujuanEntity.alamat;
                                      tujuan = state.tujuanEntity;
                                    }
                                  },
                                  builder: (context, state) {
                                    return InkWell(
                                      onTap: () => context
                                          .read<HomeBloc>()
                                          .onTujuanTap(context
                                              .read<CurrentLocationBloc>()),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 100),
                                        child: TextFormField(
                                          // expands: true,
                                          maxLines: null,
                                          controller: txtTujuan,
                                          enabled: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: const InputDecoration(
                                            hintText: "Pilih tujuan",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field ini harus diisi";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text("Catatan Alamat"),
                                TextFormField(
                                  controller: txtCatatanAlamat,
                                  decoration: const InputDecoration(
                                    hintText: "Contoh: Berhenti Depan Gg 8",
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text("Nama Barang"),
                                TextFormField(
                                  controller: txtNamaBarang,
                                  decoration: const InputDecoration(
                                    hintText: "Contoh: Sayur Kangkung",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field ini harus diisi";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text("Estimasi Berat Muatan (kg)"),
                                TextFormField(
                                  controller: txtBerat,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Contoh: 13",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field ini harus diisi";
                                    }
                                    return null;
                                  },
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 32),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<HomeBloc>()
                                                .onPilihArmada(
                                                    asal,
                                                    tujuan,
                                                    int.parse(txtBerat.text),
                                                    txtNamaBarang.text,
                                                    txtCatatanAlamat.text);
                                          }
                                        },
                                        child: const Text("Cek Armada")))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
