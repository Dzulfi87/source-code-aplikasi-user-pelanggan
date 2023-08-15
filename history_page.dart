import 'package:angkutan_sayur_user/component/func.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/data/model/transaksi_histori_model.dart';
import 'package:angkutan_sayur_user/presentation/pages/home/booking/lacak_pesanan_page.dart';
import 'package:angkutan_sayur_user/presentation/pages/main/bukti_pengiriman_page.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/histori/histori_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/histori/histori_state.dart';
import 'package:angkutan_sayur_user/presentation/widgets/dash_line.dart';
import 'package:angkutan_sayur_user/presentation/widgets/ticket_clip2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TransaksiHistoriModel> list = [];

  Widget _statusPengiriman(TransaksiHistoriModel transaksiHistoriModel) {
    String status = transaksiHistoriModel.status;
    if (status == "SELESAI") {
      return TextButton(
          onPressed: () {
            Func.navigatorHelper.push(BuktiPengirimanPage(
                bukti_pembayaran: transaksiHistoriModel.buktiPengiriman ?? ""));
          },
          child: const Text("Bukti Pengiriman"));
    } else if (status == "DIPROSES") {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsConstant.green, // Background color
          ),
          onPressed: () {
            Func.navigatorHelper.push(LacakPesananPage(
              faktur: transaksiHistoriModel.faktur,
              transaksiHistoriModel: transaksiHistoriModel,
            ));
          },
          child: const Text("Lacak Pengiriman"));
    } else {
      return Center(child: Text(status));
    }
  }

  @override
  Widget build(BuildContext c) {
    return BlocProvider(
      create: (_) => HistoriBloc()..onLoadHistori(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("History"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: BlocBuilder<HistoriBloc, HistoriState>(
            builder: (context, state) {
              if (state is LoadHistoriState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                list.clear();
                list.addAll((state as HistoriLoadedState).listTransaksi);
                return RefreshIndicator(
                  onRefresh: () => context.read<HistoriBloc>().onLoadHistori(),
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      TransaksiHistoriModel transaksiHistoriModel = list[index];
                      return ClipPath(
                        clipper: CustomTicketShape(),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child:
                                              Text(transaksiHistoriModel.asal)),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Text(
                                            transaksiHistoriModel.tujuan,
                                            textAlign: TextAlign.end,
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      transaksiHistoriModel.catatanAlamat ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      transaksiHistoriModel.namaBarang,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: Text(
                                              transaksiHistoriModel.layanan)),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Text(
                                            transaksiHistoriModel.tanggal,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const DashLine(
                                  color: ColorsConstant.greenLight,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: _statusPengiriman(
                                        transaksiHistoriModel))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
