import 'package:angkutan_sayur_user/component/func.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/data/model/tanda_terima_model.dart';
import 'package:angkutan_sayur_user/presentation/pages/main/main_page.dart';
import 'package:angkutan_sayur_user/presentation/widgets/dash_line.dart';
import 'package:flutter/material.dart';

class TandaTerimaPage extends StatelessWidget {
  const TandaTerimaPage({Key? key, required this.tandaTerimaModel}) : super(key: key);
  final TandaTerimaModel tandaTerimaModel;
  @override
  Widget build(BuildContext context) {
    return TandaTerimaView(tandaTerimaModel: tandaTerimaModel,);
  }
}

class TandaTerimaView extends StatefulWidget {
  const TandaTerimaView({Key? key, required this.tandaTerimaModel}) : super(key: key);
  final TandaTerimaModel tandaTerimaModel;

  @override
  State<TandaTerimaView> createState() => _TandaTerimaViewState();
}

class _TandaTerimaViewState extends State<TandaTerimaView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Func.navigatorHelper.pushAndRemoveUntil(const MainPage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tanda Terima"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Func.navigatorHelper.pushAndRemoveUntil(const MainPage())
            ,
          ),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(right: 16,left: 16,bottom: 4,top: index == 0 ? 20 : 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(flex: 1,child: Text(widget.tandaTerimaModel.asal!,style: const TextStyle(fontSize: 12),)),
                          Flexible(flex: 1,child: Text(widget.tandaTerimaModel.tujuan!,style: const TextStyle(fontSize: 12),textAlign: TextAlign.right,)),
                        ],
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nomor",style: TextStyle(fontSize: 12, color: ColorsConstant.green, fontWeight: FontWeight.w600),),
                                Text(widget.tandaTerimaModel.faktur!,style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                const Text("Antrian",style: TextStyle(fontSize: 12, color: ColorsConstant.green, fontWeight: FontWeight.w600),),
                                Text("${widget.tandaTerimaModel.antrian!}",style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(widget.tandaTerimaModel.jam!,style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),),
                                Text(widget.tandaTerimaModel.tanggal!,style: const TextStyle(fontSize: 12, color: Colors.grey),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16,),

                      const DashLine(color: ColorsConstant.green,),
                      const SizedBox(height: 6,)
                    ],
                  ),
                ),
              ),
            );
          },

        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          ),
          child: BottomAppBar(
            child:ElevatedButton(
              onPressed:  () {
                Func.navigatorHelper.pushAndRemoveUntil(const MainPage());
              } ,
              child:  const Text("Kembali ke Beranda") ,
            ),
          ),
        ),
      ),
    );
  }
}

