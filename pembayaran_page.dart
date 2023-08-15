import 'dart:io';

import 'package:angkutan_sayur_user/component/func.dart';
import 'package:angkutan_sayur_user/data/constants/assets_constant.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/data/constants/config_constant.dart';
import 'package:angkutan_sayur_user/data/model/paymen_model.dart';
import 'package:angkutan_sayur_user/data/model/transaksi_model.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pembayaran/pembayaran_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pembayaran/pembayaran_state.dart';
import 'package:angkutan_sayur_user/presentation/widgets/dash_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PembayaranPage extends StatelessWidget {
  const PembayaranPage({Key? key, required this.transaksiModel})
      : super(key: key);
  final TransaksiModel transaksiModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PembayaranBloc()..loadGeneral(transaksiModel),
      child: PembayaranView(
        transaksiModel: transaksiModel,
      ),
    );
  }
}

class PembayaranView extends StatefulWidget {
  const PembayaranView({Key? key, required this.transaksiModel})
      : super(key: key);
  final TransaksiModel transaksiModel;

  @override
  State<PembayaranView> createState() => _PembayaranViewState();
}

class _PembayaranViewState extends State<PembayaranView> {
  PaymentModel? paymentModel;
  final List<String> listPembayaran = [
    'Tunai',
    'QR',
    'Transfer',
    'Item4',
  ];
  String? selectedPembayaran;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    late PaymentModel paymentModel;
    late TransaksiModel transaksiModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: BlocBuilder<PembayaranBloc, PembayaranState>(
          builder: (context, state) {
            if (state is InitState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadedGeneralState ||
                state is PembayaranTerpilihState ||
                state is ImageBuktiTerpilihState) {
              if (state is LoadedGeneralState) {
                paymentModel = state.paymentModel;
                transaksiModel = state.transaksiModel;
              }
              return Card(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Estimasi Jarak Tempuh"),
                              Text("${transaksiModel.jarakTempuh}km"),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tarif per KM"),
                              Text("Rp ${paymentModel.tarif}"),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Ongkos Angkut"),
                              Text(
                                  "Rp ${int.parse(paymentModel.tarif) * transaksiModel.jarakTempuh!}"),
                            ],
                          )
                        ],
                      ),
                    ),
                    const DashLine(
                      color: ColorsConstant.greenLight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Metode Pembayaran"),
                          DropdownButton2(
                            hint: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: paymentModel.metode_pembayaran
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedPembayaran,
                            onChanged: (value) {
                              selectedPembayaran = value as String;
                              context
                                  .read<PembayaranBloc>()
                                  .onPembayaranTerpilih();
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              // width: double.infinity,
                            ),
                            isExpanded: true,
                            dropdownStyleData: const DropdownStyleData(
                                decoration: BoxDecoration(color: Colors.white)),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text("Upload Bukti*"),
                          const SizedBox(
                            height: 12,
                          ),
                          InkWell(
                            onTap: () => context
                                .read<PembayaranBloc>()
                                .onChooseImageBukti(),
                            child: BlocBuilder<PembayaranBloc, PembayaranState>(
                              builder: (context, state) {
                                if (state is ImageBuktiTerpilihState) {
                                  imageFile = state.imageFile;
                                }
                                return imageFile == null
                                    ? Image.asset(AssetsConstant.imgEmpty)
                                    : Image.file(imageFile!);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "*Jika menggunakan metode bayar QRIS",
                            style: TextStyle(
                                fontSize: 12, color: ColorsConstant.green),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible: selectedPembayaran != null &&
                            selectedPembayaran == "QRIS",
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              context.read<PembayaranBloc>().unduhQris();
                            },
                            child: Text("Unduh QRIS"),
                          ),
                        ))
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        child: BottomAppBar(
          child: BlocBuilder<PembayaranBloc, PembayaranState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: selectedPembayaran != null
                    ? () {
                        transaksiModel.ongkos =
                            double.parse(paymentModel.tarif) *
                                transaksiModel.jarakTempuh!;
                        transaksiModel.tarif = double.parse(paymentModel.tarif);
                        transaksiModel.metodePembayaran = selectedPembayaran!;
                        transaksiModel.pelangganId = int.parse(Func.cache
                            .getString(ConfigConstant.idUser,
                                cDefaultValue: "0"));
                        context.read<PembayaranBloc>().onBayar(transaksiModel,
                            imageFile == null ? "" : imageFile!.path);
                      }
                    : null,
                child: Text(selectedPembayaran != null
                    ? "Pesan Sekarang"
                    : "Pilih Pembayaran Dulu"),
              );
            },
          ),
        ),
      ),
    );
  }
}
