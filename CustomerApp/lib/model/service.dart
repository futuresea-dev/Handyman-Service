import 'package:abg_utils/abg_utils.dart';
import 'model.dart';

class MainModelService {
  final MainModel parent;
  MainModelService({required this.parent});

  ImageData getTitleImage(){
    if (parent.currentService.gallery.isNotEmpty)
      return parent.currentService.gallery[0];
    return ImageData();
  }

  PriceData getPrice(){
    PriceData currentPrice = PriceData.createEmpty();
    double _price = double.maxFinite;
    for (var item in parent.currentService.price) {
      if (item.discPrice != 0){
        if (item.discPrice < _price) {
          _price = item.discPrice;
          currentPrice = item;
        }
      }else
      if (item.price < _price) {
        _price = item.price;
        currentPrice = item;
      }
    }
    if (_price == double.maxFinite)
      _price = 0;
    return currentPrice;
  }

}

