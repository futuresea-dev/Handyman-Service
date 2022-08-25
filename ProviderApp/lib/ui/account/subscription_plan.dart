import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:flutter_html/flutter_html.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  @override
  _SubscriptionPlanScreenState createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen>  with TickerProviderStateMixin{

  final _controllerResizer = ScrollerResizerController();

  @override
  void dispose() {
    _controllerResizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
  }

  _init() async {
    waitInMainWindow(true);
    var ret = await loadSubscriptions();
    if (ret != null)
      messageError(context, ret);
    waitInMainWindow(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20,),
                  child: ListView(
                    children: _getList(),
                  ),
                ),

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, "", context, () {
                  goBack();
                }),

              ],
            ))

    );
  }

  List<Widget> w = [];
  _buildSubscriptions(){
    w = [];
    for (var item in subscriptions) {
      w.add(Column(
            children: [
              subscriptionItem(210, item,
                item.price == 0 ? strings.get(281) : strings.get(282), /// "Start Free Trial Now", /// "Start",
                  strings.get(287), /// Free Trial
                      () async {
                    currentSubscription = item;
                    if (item.price != 0) {
                      route("pay_subscription");
                    }else{
                      waitInMainWindow(true);
                      var ret = await subscriptionFinish("free trial");
                      if (ret != null)
                        return messageError(buildContext, ret);
                      waitInMainWindow(false);
                      goBack();
                      redrawMainWindow();
                    }
                  }
              ),
              SizedBox(height: 10,),
            ],
          ));
    }
    _controllerResizer.childs = w;
    _controllerResizer.update();
  }

  _getList(){
    List<Widget> list = [];

    _buildSubscriptions();

    list.add(Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
                color: Colors.grey.withAlpha(20),
                child: ScrollerResizer(
                  windowWidth: windowWidth,
                  childWidth: 210,
                  controller: _controllerResizer,
                )
            )
          ],
        )
    );

    list.add(Container(
      margin: EdgeInsets.all(15),
      child: Html(
          data: "<body>${appSettings.subscriptionsPromotionText}",
          style: {
            "body": Style(
                backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                color: (theme.darkMode) ? Colors.white : Colors.black
            ),
          }
      ),
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }
}
