// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import 'package:flutter/services.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'package:regexed_validator/regexed_validator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../core/api_services.dart';
import '../../../core/colors.dart';
import '../widgets/address_text_field.dart';

// import 'package:geolocator/geolocator.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AddAddressPage extends StatefulWidget {
  const AddAddressPage(
      {super.key, required this.userId, required this.edit, this.food});

  final String userId;
  final bool edit;
  final bool? food;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String locationMessage = 'Current Location of the User';
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are Permanently denied, we cannot request');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });
    setState(() {
      locationMessage = 'Latitude: $lat , Longitude: $long';
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey

  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _lanMarkController = TextEditingController();
  final TextEditingController _doorController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    log('User Id is......');
    log(widget.userId);
    // _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Address',
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              onChanged: () {
                if (_formKey.currentState != null) {
                  _formKey.currentState!.validate();
                }
              },
              child: Column(
                children: [
                  AddressTextField(
                    inpuitType: TextInputType.number,
                    title: 'Pincode',
                    length: 6,
                    controller: _pinCodeController,
                    validator: (value) {
                      // if (value == null ||
                      //     value.length < 6 ||
                      //     value.isEmpty ||
                      //     !validator.numbers(value!)) {
                      //   return 'Please Enter Correct Pincode';
                      // }
                      // return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.text,
                    title: 'Door No / Flat no',
                    controller: _doorController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }
                      return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.streetAddress,
                    title: 'Area/Colony/RoadName',
                    controller: _areaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }
                      return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.streetAddress,
                    title: 'LandMark',
                    controller: _lanMarkController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }
                      return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.streetAddress,
                    title: 'Place',
                    controller: _placeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }

                      return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.streetAddress,
                    title: 'District',
                    controller: _districtController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }
                      return null;
                    },
                  ),
                  AddressTextField(
                    inpuitType: TextInputType.streetAddress,
                    title: 'State',
                    controller: _stateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This feild is required.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // saran code
            // 
            // 

             const SizedBox(
              height: 20,
            ),
            Text(
              locationMessage,
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                // style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all(Colors.blue)
                // ),
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    // print(value.latitude);
                    setState(() {
                      lat = value.latitude.toString();
                      long = value.longitude.toString();
                      locationMessage = 'Latitude: $lat , Longitude: $long';
                    });
                    _liveLocation();
                    // lat = '${value.latitude}';
                    // long = '${value.longitude}';
                  });
                  // setState(() {
                  //   locationMessage = 'Latitude: $lat , Longitude: $long';
                  // });
                },
                child: const Text(
                  "Get Current Location",
                  style: TextStyle(color: Colors.black),
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _openMap(lat, long);
                },
                child: Text('Open Google Map')),
            //

            isLocationFetching
                ? const CircularProgressIndicator()
                : IconButton(
                    // onPressed: _fetchCurrentLocation,
                    onPressed: () {
                      // _getLocation();
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.place),
                    ),
                  ),
            if (widget.edit == true)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendEditRequestAddress();
                    _formKey.currentState!.reset();
                  } else {
                    showErrorMsg();
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.purple),
                ),
                child: const Text(
                  'Update Address',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            else if (widget.edit == false && widget.food == false)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendCreateRequestAddress();
                    _formKey.currentState!.reset();
                  } else {
                    showErrorMsg();
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.purple),
                ),
                child: const Text(
                  'Save Address',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            if (widget.food == true)
              ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.purple),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ))
          ],
        ),
      ),
    );
  }

  showErrorMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        // width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.red,
        content: Center(
          child: Text('Please Enter All Feilds'),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  showSuccessrMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        // width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.green,
        content: Center(
          child: Text('Address added successfully'),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void sendCreateRequestAddress() async {
    String url =
        'https://${ApiServices.ipAddress}/end_user_address/${widget.userId}';
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['doorno'] = _doorController.text;
      request.fields['area'] = _areaController.text;
      request.fields['landmark'] = _lanMarkController.text;
      request.fields['place'] = _placeController.text;
      request.fields['district'] = _districtController.text;
      request.fields['state'] = _stateController.text;
      request.fields['pincode'] = _pinCodeController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        log('Address add successfully ');
        String responseBody = await response.stream.bytesToString();
        responseBody = responseBody.trim().replaceAll('"', '');

        Navigator.pop(context);
        Navigator.pop(context);

        showSuccessrMsg();
      } else {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check the Datas you have entered'),
          ),
        );

        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void sendEditRequestAddress() async {
    String url =
        'https://${ApiServices.ipAddress}/update_end_user_address/${widget.userId}';
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['doorno'] = _doorController.text;
      request.fields['area'] = _areaController.text;
      request.fields['landmark'] = _lanMarkController.text;
      request.fields['place'] = _placeController.text;
      request.fields['district'] = _districtController.text;
      request.fields['state'] = _stateController.text;
      request.fields['pincode'] = _pinCodeController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        log('Address add successfully ');
        String responseBody = await response.stream.bytesToString();
        responseBody = responseBody.trim().replaceAll('"', '');

        Navigator.pop(context);
        Navigator.pop(context);

        showSuccessrMsg();
      } else {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check the Datas you have entered'),
          ),
        );

        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  double longitude = 0.0;
  double latitude = 0.0;

  // Flag to indicate location fetching status
  bool isLocationFetching = false;

  bool isLocationEnabled = false;

  // LocationData? _currentLocation;

  // Future<void> _getLocation() async {
  //   Location location = Location();
  //   try {
  //     _currentLocation = await location.getLocation();
  //     log(_currentLocation.toString());
  //     setState(() {});
  //   } catch (e) {
  //     print('Failed to get location: $e');
  //   }
  // }

  // Future<void> _checkLocationPermission() async {
  //   PermissionStatus status = await Permission.location.status;
  //   if (status.isDenied) {
  //     // Request permission if denied
  //     status = await Permission.location.request();
  //   }

  //   if (status.isGranted) {
  //     // Permission granted, proceed with location access
  //     print('Location permission granted');
  //   } else if (status.isPermanentlyDenied) {
  //     // Handle permanently denied permission (e.g., open app settings)
  //     print('Location permission permanently denied');
  //     await openAppSettings();
  //   } else {
  //     // Handle other permission statuses (e.g., undetermined)
  //     print('Location permission status: $status');
  //   }
  // }

  // void getCurrentLocation() async {
  //   var status = await Permission.location.status;
  //   setState(() {
  //     isLocationFetching = true;
  //   });
  //   try {
  //     if (status.isGranted) {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //       setState(() {
  //         isLocationFetching = false;
  //       });

  //       print('Latitude: $latitude, Longitude: $longitude');
  //     } else if (status.isDenied) {
  //       setState(() {
  //         isLocationFetching = false;
  //       });
  //       var result = await Permission.location.request();
  //       if (result.isGranted) {
  //         getCurrentLocation();
  //       } else {}
  //     } else {}
  //   } catch (e) {
  //     setState(() {
  //       isLocationFetching = false;
  //     });
  //     print("error $e");
  //   }
  // }
}
