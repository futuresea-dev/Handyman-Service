import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ondemand_admin/ui/subscription.dart';
import '../ui/strings.dart';
import '../ui/theme.dart';
import '../utils.dart';
import 'initData/statuses.dart';
import 'model.dart';

class MainDataModelSettings {

  final MainModel parent;

  MainDataModelSettings({required this.parent});

  int _lastBookingNewCount = -1;

  Future<String?> settings(BuildContext context, Function()? _redrawMenu) async {

    parent.callback(strings.get(203)); /// "Loading settings ...",

    await loadSettings(() async {
      parent.langEditDataComboValue = appSettings.defaultServiceAppLanguage;
      parent.statusesCombo = [];
      parent.statusesComboForBookingSearch = [];
      parent.statusesComboForBookingSearch.add(ComboData(strings.get(254), "-1"));  // "All"
      if (appSettings.statusesFound){
        for (var item in appSettings.statuses){
          parent.statusesCombo.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
          parent.statusesComboForBookingSearch.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
        }
      }else{
        await uploadStatusImages(parent.callback);
        await saveStatuses();
      }
      statusesGetCompleted();
      theme = AppTheme(appSettings.adminDarkMode);
      if (_redrawMenu != null)
        _redrawMenu();

      if (_lastBookingNewCount == 0)
        if (_lastBookingNewCount != appSettings.bookingCountUnread){
          _lastBookingNewCount = appSettings.bookingCountUnread;
          parent.playSound();
        }
      if (_lastBookingNewCount == -1)
        _lastBookingNewCount = 0;

      if (!appSettings.subscriptionsInitialized) {
        appSettings.subscriptionsPromotionText = '''<div class="col-lg-12 col-md-12 sm-mt-30"><div class="who-we-are-left"><div class=""><div class=""><a href="fotospages/mac_our_history_1518813276.jpg" data-fancybox-caption="About our company" class="" data-fancybox="galeria"><img src="fotospages/thu_our_history_1518813276.jpg" alt="About our company" class="img-responsive"></a></div></div></div><div class="section-title st-secciones"><h2 class="title-effect">About our company</h2></div><p>&nbsp;</p><p>Western Pacific Engineering Group Limited (<strong>WPEG</strong>) has an entrepreneurial spirit that allows us to be responsive to our clients. We work as a motivated team that delivers innovative, practical solutions that fulfill project needs and fit within the reality of our client’s budgets. Our business model allows us to deliver the best service in our industry and foster successful client relationships.</p><p><strong>WPEG</strong> cultivates an environment that encourages collaboration, continuous improvement and community involvement. As a responsive and flexible engineering company, we have established a solid reputation because we enjoy what we do.</p><p>We strive to maximize the efficiency of the civil infrastructure we design, while minimizing the construction and operations costs to our clients. Everything we design will eventually be built, and the leverage our design has over the cost of construction is considerable.</p><p>We aim to design civil infrastructure to have high standards while respecting environmental sustainability. We also endeavor to reduce the impact of our own operations through careful selection of supplies, reduction of power consumption and recycling.</p><p>&nbsp;</p><p>Elizabeth De Leon Gonzalez, Civil Engineer in Mexico, started working for Western Pacific Engineering Group Ltd. since 2018 as Civil Designer. Elizabeth De Leon, or Eliza Bennett (Unofficial Canadian name / nick name) already started her accreditation with Association on Engineers of British Columbia to obtain her Civil Engineer designation in Canada. Elizabeth De Leon Gonzalez has been involved in multiples projects for different disciplines, including septic systems and preliminary Municipal Civil design. Elizabeth De Leon was also part of a commission of professionals seeking to learn the way Mission landfill operates so it can be implemented in Bucaramanga, Colombia considering the challenges they are currently facing on their landfill.</p><p>&nbsp;</p><p>&nbsp;</p><h4><strong>Mission</strong></h4><p>Our mission is to expand a reputation based on excellence, innovation and the application of cost-effective solutions that meet our client’s expectations.</p><h4><strong>Vision</strong></h4><p>To build a safer tomorrow and ensure a better quality of life for our customers and our community.</p><h4><strong>Values</strong></h4><p>Commitment to sustainability and to acting in an environmentally friendly way. Commitment to innovation and excellence. A commitment to building strong communities, Respect, Dignity, Fairness, Caring, Equality, and Self-esteem.</p></div>''';
        subscriptions = subscriptionsTemplate;
        saveSubscriptions();
        appSettings.subscriptionsInitialized = true;
        saveSettings();
      }

    });

    if (!appSettings.bookingToCashMigrate){
     // await FirebaseFirestore.instance.collection("cache").doc("orders").delete();
      parent.callback(strings.get(454)); /// "Convert bookings ... ",
      await bookingToCashMigrate((String error) async {
        if (error.isNotEmpty)
          messageError(context, error);
      });
    }
    return null;
  }

  Future<String?> saveProviderAreaMap() async{
    try{
      var _data = {
        "providerAreaMapZoom": appSettings.providerAreaMapZoom,
        "providerAreaMapLat" : appSettings.providerAreaMapLat,
        "providerAreaMapLng" : appSettings.providerAreaMapLng,
      };
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return "saveProviderAreaMap " + ex.toString();
    }
    return null;
  }

  statusesGetCompleted(){
    appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
    parent.completeStatus = "";
    // List<StringData> name = [];
    for (var item in appSettings.statuses)
      if (!item.cancel) {
        parent.completeStatus = item.id;
        // name = item.name;
      }
    // print("statusesGetCompleted ${parent.completeStatus} $name" );
  }

  moveUp(StatusData item){
    StatusData? _last;
    for (var item2 in appSettings.statuses){
      if (item2.id == item.id){
        if (_last == null)
          return;
        var _position = item.position;
        item.position = _last.position;
        _last.position = _position;
        appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
        return parent.notify();
      }
      _last = item2;
    }
  }

  delete(StatusData item, BuildContext context, Function() _redraw){
    openDialogDelete(() {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      appSettings.statuses.remove(item);
      appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
      _redraw();
    }, context);
  }

  moveDown(StatusData item){
    bool searched = false;
    for (var item2 in appSettings.statuses){
      if (item2.id == item.id){
        searched = true;
        continue;
      }
      if (searched) {
        var _position = item2.position;
        item2.position = item.position;
        item.position = _position;
        appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
        return parent.notify();
      }
    }
  }

  select(StatusData select){
    parent.currentStatus = select;
    parent.notify();
  }

  setName(String val){
    for (var item in parent.currentStatus.name)
      if (parent.langEditDataComboValue == item.code) {
        item.text = val;
        return;
      }
    parent.currentStatus.name.add(StringData(code: parent.langEditDataComboValue, text: val));
  }

  create(){
    var pos = 0;
    for (var item in appSettings.statuses)
      if (item.position >= pos)
        pos = item.position + 1;

    parent.currentStatus.position = pos;
    parent.currentStatus.id = UniqueKey().toString();
    appSettings.statuses.add(parent.currentStatus);
    appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
  }

  Future<String?> saveStatuses() async{
    statusesGetCompleted();
    var _data = {
      "statuses": appSettings.statuses.map((i) => i.toJson()).toList(),
    };
    try{
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    return null;
  }
}

