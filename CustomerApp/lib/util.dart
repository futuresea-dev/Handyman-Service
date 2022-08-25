import 'package:abg_utils/abg_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'model/model.dart';

getAddressFromLatLng(LatLng pos, MainModel _mainModel) async {
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: appSettings.googleMapApiKey);
  PlacesSearchResponse response = await places.searchNearbyWithRadius(Location(lat: pos.latitude, lng: pos.longitude), 20);
  if (response.results.isEmpty)
    return "";
  if (!response.isOkay)
    return response.errorMessage;
  var _textAddress = "";
  if (response.results.isNotEmpty) {
    for (var item in response.results)
      if (item.vicinity != null)
        if (item.vicinity!.length > _textAddress.length)
          _textAddress = item.vicinity!;
  }
  return _textAddress;
}
