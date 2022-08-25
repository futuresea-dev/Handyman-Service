import 'package:abg_utils/abg_utils.dart';
import 'package:ondprovider/ui/strings.dart';
import 'model.dart';

class MainDataService {

  final MainModel parent;

  MainDataService({required this.parent});

  List<ComboData> priceUnitCombo = [
    ComboData(strings.get(156), "hourly"),
    ComboData(strings.get(157), "fixed"),
  ];
  String priceUnitComboValue = "hourly";
}

