import 'package:angkutan_sayur_user/data/constants/assets_constant.dart';
import 'package:angkutan_sayur_user/data/model/notification_model.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/notification/notificatioin_state.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(create: (_)=> NotificationBloc()..loadNotification(), child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notifikasi"),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state){
          print('mamama');
            if(state is InitState){
              print('mamama 1');

              return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
              print('mamama 2');

              List<NotificationModel> list = (state as NotificationLoadedState).listNotif;
            return ListView.builder(itemCount: list.length,
                itemBuilder: (c,i){
              NotificationModel notificationModel = list[i];
                  return Container(
                    margin: EdgeInsets.only(left: 16, right: 16,top: i == 0 ? 16 : 0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.asset(AssetsConstant.imgNotif),
                            const SizedBox(width: 16,),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(notificationModel.namaBarang,style: const TextStyle(fontWeight: FontWeight.w500)),
                                      Text(notificationModel.tanggal,style: const TextStyle(color: Colors.grey),),
                                    ],),
                                  const SizedBox(height: 4,),
                                  Text(notificationModel.tujuan),
                                  const SizedBox(height: 8,),
                                  Text(notificationModel.status,style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    ),);
  }
}
