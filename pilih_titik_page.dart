import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pilih_titik/pilih_titik_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/pilih_titik/pilih_titik_state.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/service/current_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PilihTitikPage extends StatelessWidget {
  const PilihTitikPage(
      {Key? key, required this.isAsal, required this.currentLocationBloc})
      : super(key: key);
  final bool isAsal;
  final CurrentLocationBloc currentLocationBloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PilihTitikBloc(currentLocationBloc)..onInitial(),
      child: PilihTitikView(
        isAsal: isAsal,
      ),
    );
  }
}

class PilihTitikView extends StatefulWidget {
  const PilihTitikView({Key? key, required this.isAsal}) : super(key: key);
  final bool isAsal;
  @override
  State<PilihTitikView> createState() => _PilihTitikViewState();
}

class _PilihTitikViewState extends State<PilihTitikView> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.983908, 112.621391),
    zoom: 14.4746,
  );
  late Marker _markers;
  late GoogleMapController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: Text(widget.isAsal ? "Pilih Titik Asal" : "Pilih Titik Tujuan"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: BlocBuilder<PilihTitikBloc, PilihTitikState>(
              builder: (BuildContext context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: ColorsConstant.greyBorder,
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 3)), //BoxShadow
                          ],
                        ),
                        child: TextFormField(
                          onTap: () =>
                              context.read<PilihTitikBloc>().onSearchTap(),
                          onChanged: (t) {},
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) {
                            context.read<PilihTitikBloc>().doSearch(value);
                          },
                          // controller: g.txtQuery,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: "Cari...",
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state is SearchState ||
                            state is SearchingState ||
                            state is SearchDoneState,
                        child: TextButton(
                          onPressed: () {
                            context.read<PilihTitikBloc>().onCancelSearch();
                          },
                          child: const Text("Cancel"),
                        ))
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<PilihTitikBloc, PilihTitikState>(
            builder: (BuildContext context, state) {
              List<(String, String)> listLokasi = [];
              if (state is SearchDoneState) {
                listLokasi = state.listLokasi;
              } else if (state is MarkerLoadedState) {
                _markers = state.marker;
                if (state.moveMarker) {
                  _controller.animateCamera(
                      CameraUpdate.newLatLngZoom(state.marker.position, 20));
                }
              }
              return Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        context.read<PilihTitikBloc>().onMyLocationUpdate();
                      },
                      onCameraIdle: () {
                        if (state is! InitialState) {
                          _controller.getVisibleRegion().then((value) =>
                              context.read<PilihTitikBloc>().onMapsMove(value));
                        }
                      },
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: ColorsConstant.greenSuperLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(state is MarkerLoadedState
                                    ? _markers.infoWindow.title!
                                    : state is LoadingLatLngState
                                        ? "Loading..."
                                        : ""),
                              ),
                            ),
                            const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state is SearchState ||
                            state is SearchingState ||
                            state is SearchDoneState,
                        child: Container(
                          height: double.infinity,
                          color: Colors.white,
                          child: Expanded(
                            child: ListView.separated(
                              itemCount: listLokasi.length,
                              itemBuilder: (BuildContext context, int index) {
                                (String, String) lokasi = listLokasi[index];
                                return ListTile(
                                  onTap: () => context
                                      .read<PilihTitikBloc>()
                                      .onLokasiListTap(lokasi),
                                  title: Text(lokasi.$2),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          ),
                        ))
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        child: BottomAppBar(
          child: BlocBuilder<PilihTitikBloc, PilihTitikState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is! InitialState
                    ? () => context
                        .read<PilihTitikBloc>()
                        .onPilihTitikButton(_markers, context)
                    : null,
                child: Text(state is! InitialState
                    ? "Pilih Titik Ini"
                    : "Tunggu sebentar.."),
              );
            },
          ),
        ),
      ),
    );
  }
}
