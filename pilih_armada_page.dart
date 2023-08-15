import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/data/model/armada_model.dart';
import 'package:angkutan_sayur_user/data/model/transaksi_model.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pilih_armada/pilih_armada_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pilih_armada/pilih_armada_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PilihArmadaPage extends StatelessWidget {
  const PilihArmadaPage({Key? key, required this.transaksiModel}) : super(key: key);

  final TransaksiModel transaksiModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_)=>PilihArmadaBloc(),child:  PilihArmadaView(transaksiModel: transaksiModel,),);
  }
}

class PilihArmadaView extends StatefulWidget {
  const PilihArmadaView({Key? key, required this.transaksiModel}) : super(key: key);
  final TransaksiModel transaksiModel;

  @override
  State<PilihArmadaView> createState() => _PilihArmadaViewState();
}

class _PilihArmadaViewState extends State<PilihArmadaView> {
  int selectedArmada =-1;
  List<ArmadaModel> armadaList = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PilihArmadaBloc>().onLoadArmada(widget.transaksiModel.estimasiBerat!);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Armada"),
      ),
      body: BlocBuilder<PilihArmadaBloc,PilihArmadaState>(
        builder: (context, state){
          if(state is ArmadaTapState){
            selectedArmada = state.selectedPos;
          }
          if(state is LoadedArmadaState){
            armadaList.clear();
            armadaList.addAll(state.armadaList);
          }
          return ListView.builder(itemCount: armadaList.length,itemBuilder: (BuildContext context, int index) {
            ArmadaModel armadaModel = armadaList[index];
            return  Container(
              margin: EdgeInsets.only(left: 13,right: 13, top: index == 0 ? 16 : 3),
              child: Card(
                color: selectedArmada == index ? ColorsConstant.green.withOpacity(0.2) : Colors.white,
                child: InkWell(
                  onTap: ()=>context.read<PilihArmadaBloc>().onArmadaTap(index,armadaModel),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                    child: Column(
                      children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(armadaModel.keterangan,style: const TextStyle(
                              color: ColorsConstant.yellow, fontSize: 16, fontWeight: FontWeight.w700
                            ),),
                            Text(armadaModel.status,style: const TextStyle(
                                color: ColorsConstant.green, fontSize: 12, fontWeight: FontWeight.w700
                            )),
                          ],
                        ),
                        const SizedBox(height: 4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Jumlah Antrian",style: TextStyle(
                                fontSize: 12, color: ColorsConstant.green
                            ),),
                            Text("${armadaModel.antrian }",style: const TextStyle(
                                fontSize: 12, color: ColorsConstant.green
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },);
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        child: BottomAppBar(
          child: BlocBuilder<PilihArmadaBloc,PilihArmadaState>(
            builder: (context,state){
              return ElevatedButton(
                onPressed: selectedArmada >= 0 ? () => context.read<PilihArmadaBloc>().onButtonPilihArmadaTap(widget.transaksiModel, armadaList[selectedArmada].id) : null,
                child:  Text(selectedArmada >= 0 ? "Pesan Sekarang": "Pilih armada dahulu..") ,
              );
            },
          ),
        ),
      ),
    );
  }
}

