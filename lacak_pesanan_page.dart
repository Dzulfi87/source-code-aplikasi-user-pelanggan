import 'package:angkutan_sayur_user/component/services/mqtt_client_service.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/data/model/directions_model.dart';
import 'package:angkutan_sayur_user/data/model/lacak_model.dart';
import 'package:angkutan_sayur_user/data/model/transaksi_histori_model.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/lacak_pesanan/lacak_pesanan_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/lacak_pesanan/lacak_pesanan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:angkutan_sayur_user/injection.dart' as inj;

class LacakPesananPage extends StatelessWidget {
  const LacakPesananPage(
      {Key? key, required this.faktur, required this.transaksiHistoriModel})
      : super(key: key);
  final String faktur;
  final TransaksiHistoriModel transaksiHistoriModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LacakPesananBloc(),
      child: LacakPesananView(
        faktur: faktur,
        transaksiHistoriModel: transaksiHistoriModel,
      ),
    );
  }
}

class LacakPesananView extends StatefulWidget {
  const LacakPesananView(
      {Key? key, required this.faktur, required this.transaksiHistoriModel})
      : super(key: key);
  final String faktur;
  final TransaksiHistoriModel transaksiHistoriModel;

  @override
  State<LacakPesananView> createState() => _LacakPesananViewState();
}

class _LacakPesananViewState extends State<LacakPesananView> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.983908, 112.621391),
    zoom: 14.4746,
  );
  late LacakModel lacakModel;
  late GoogleMapController mapController;
  late DirectionsModel directionsModel;
  Set<Polyline> polylines = {};
  Set<Marker> markersDirection = {};
  Set<Marker> markers = {};
  BitmapDescriptor driverIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  void _setMapFitToTour(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });
    mapController.moveCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  Future<void> generateIcon() async {
    // driverIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(10, 10)),
    //     "assets/images/img_car.png");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    markersDirection = {
      Marker(
          markerId: const MarkerId("0"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(widget.transaksiHistoriModel.latitudeAsal,
              widget.transaksiHistoriModel.longitudeTujuan)),
      Marker(
          markerId: const MarkerId("1"),
          icon: BitmapDescriptor.defaultMarkerWithHue(90),
          position: LatLng(widget.transaksiHistoriModel.latitudeTujuan,
              widget.transaksiHistoriModel.longitudeTujuan)),
    };
    markers = markersDirection;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      generateIcon();
      context.read<LacakPesananBloc>().loadDataPesanan(widget.faktur);
      await context.read<LacakPesananBloc>().loadDirections(
          LatLng(widget.transaksiHistoriModel.latitudeAsal,
              widget.transaksiHistoriModel.longitudeTujuan),
          LatLng(widget.transaksiHistoriModel.latitudeTujuan,
              widget.transaksiHistoriModel.longitudeTujuan));
      bool connect = await inj.locator<MQTTClientService>().connect();
      print('haooo $connect');
      if (connect) {
        inj.locator<MQTTClientService>().subscribeFaktur(widget.faktur);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('asuuu');
    inj
        .locator<MQTTClientService>()
        .client
        .unsubscribe("/tracking/${widget.faktur}");
    inj.locator<MQTTClientService>().disconnect();
    inj.locator<MQTTClientService>().streamController.sink.close();
    inj.locator<MQTTClientService>().streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lacak Pengiriman"),
      ),
      body: BlocBuilder<LacakPesananBloc, LacakPesananState>(builder: (c, s) {
        if (s is LoadedDirectionsState) {
          print("mamamama34");
          directionsModel = s.directionsModel;
          polylines = {
            Polyline(
              polylineId: const PolylineId('direction_polyline'),
              color: Theme.of(context).colorScheme.primary,
              width: 5,
              points: directionsModel.polylinePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            )
          };
        }
        if (s is DataPesananLoaded || s is LoadedDirectionsState) {
          if (s is DataPesananLoaded) {
            lacakModel = s.lacakModel;
          }
          return SlidingUpPanel(
            minHeight: MediaQuery.of(context).size.height * 0.16,
            panelBuilder: () {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                ),
                child: BottomAppBar(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Informasi Supir",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                      ListTile(
                        leading: const CircleAvatar(),
                        title: Text(lacakModel.nama),
                        subtitle: const Text("Delivery Man"),
                        trailing: InkWell(
                            onTap: () => launchUrl(
                                Uri.parse("tel:${lacakModel.telepon}")),
                            child: const Icon(
                              Icons.call,
                              color: ColorsConstant.green,
                            )),
                      ),
                      const Divider(
                        color: ColorsConstant.greyBorder,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              ColorsConstant.green.withOpacity(0.20),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: ColorsConstant.green,
                          ),
                        ),
                        title: const Text(
                          "Alamat tujuan",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        subtitle: Text(
                          lacakModel.tujuan,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              ColorsConstant.green.withOpacity(0.20),
                          child: const Icon(
                            Icons.access_time,
                            color: ColorsConstant.green,
                          ),
                        ),
                        title: const Text(
                          "Waktu Pengantaran",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        subtitle: Text(
                          lacakModel.waktu_pengantaran,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            body: StreamBuilder<LatLng>(
              stream: inj.locator<MQTTClientService>().streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  LatLng latLng = snapshot.data!;
                  Marker driverMarker = Marker(
                      markerId: const MarkerId("3"),
                      position: latLng,
                      icon: driverIcon);
                  markers = markersDirection;
                  markers.add(driverMarker);
                  print("mamma ada data");
                }
                return GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  polylines: polylines,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    Future.delayed(const Duration(seconds: 2)).then((_) {
                      if (polylines.isNotEmpty) {
                        _setMapFitToTour(polylines);
                      }
                    });
                  },
                );
              },
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
