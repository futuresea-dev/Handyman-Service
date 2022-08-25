import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'earning.dart';
import '../model/booking.dart';
import '../model/model.dart';
import 'strings.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _load();
    super.initState();
  }

  _load() async {
   _mainModel.booking.getStat();
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: _mainModel.getWorkspaceWidth(),
          height: windowHeight*0.3,
          color: theme.mainColor,
        ),
        Container(
          padding: EdgeInsets.all(20),
            child: ListView(
                children: _getList(),
              ),)
      ],
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));
    list.add(SelectableText(strings.get(153), style: theme.style20W800White));                          /// Home
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));

    if (windowWidth <= 700) {
      list.add(Row(
        children: [
          SizedBox(width: 20,),
          _customers(),
          SizedBox(width: 20,),
          _category(),
          SizedBox(width: 20,),
        ],
      ));
      list.add(SizedBox(height: 20,));
      list.add(Row(
        children: [
          SizedBox(width: 20,),
          _providers(),
          SizedBox(width: 20,),
          _service(),
          SizedBox(width: 20,),
        ],
      ));
    }else{
      list.add(Row(
        children: [
          SizedBox(width: 20,),
          _customers(),
          SizedBox(width: 20,),
          _category(),
          SizedBox(width: 20,),
          _providers(),
          SizedBox(width: 20,),
          _service(),
          SizedBox(width: 20,),
        ],
      ));
    }

    //
    // Chart
    //
    list.add(SizedBox(height: 20,));

    if (windowWidth <= 700) {
      list.add(_chart());
      list.add(SizedBox(height: 20,));
      list.add(_chart2());
    }else{
      list.add(
          Row(children: [
              Expanded(child: _chart()),
            SizedBox(width: 20,),
            Expanded(child: _chart2())
          ],));
    }

    //
    // Table with users
    //
    list.add(SizedBox(height: 30,));
    // list.add(Container(
    //     padding: EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(theme.radius),
    //     ),
    //     child: Column(
    //   children: [
    //     Container(
    //         padding: EdgeInsets.all(10),
    //         width: windowWidth,
    //         color: Colors.white,
    //         child: Row(
    //           children: [
    //             Expanded(child: Text(strings.get(159), //  "Last Booking",
    //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),)),
    //             UnconstrainedBox(child: SizedBox(width: 100, child: button2(strings.get(162),  // "See All",
    //                 dashboardColor, 5, (){}, true))),
    //           ],
    //         )),
    //     Container(height: _heightTable, child: _table())
    //   ],
    // )));

    list.add(Container(
      height: windowHeight*0.8,
        child: EarningScreen()));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _chart(){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1a1b4e),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      padding: EdgeInsets.all(20),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(color: Colors.white.withAlpha(150), fontWeight: FontWeight.w800),
            majorGridLines: MajorGridLines(
                width: 0,
                color: Colors.red,
                dashArray: <double>[5,5]
            ),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(
                width: 0,
                color: Colors.red,
                dashArray: <double>[5,5]
            ),
            labelFormat: '\$ {value}',
            labelStyle: TextStyle(color: Colors.white.withAlpha(150), fontWeight: FontWeight.w800),
          ),
          // Chart title
          title: ChartTitle(text: strings.get(154),                                 /// 'Earning',
              textStyle: theme.style16W800White),
          // Enable legend
          legend: Legend(isVisible: true,
              textStyle: theme.style16W800White),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<EarningDataForGraphics, String>>[
            LineSeries<EarningDataForGraphics, String>(
                dataSource: _mainModel.booking.data2,
                xValueMapper: (EarningDataForGraphics sales, _) => sales.year,
                yValueMapper: (EarningDataForGraphics sales, _) => sales.sales,
                name: strings.get(155), /// 'Sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))
          ]),
    );
  }

  _providers(){
    return Expanded(child: Button186(text1: strings.get(96).toUpperCase(), /// Providers
      style1: theme.style18W800Grey,
      text2: "${appSettings.providerCount}", style2: theme.style16W800Black,
      color: Colors.white, icon: "assets/dashboard2/prov.png",
      callback: (){print("button pressed");}, iconSize: 50, ));
  }

  _customers(){
    return Expanded(child: Button186(text1: strings.get(157).toUpperCase(), /// Customers
      style1: theme.style18W800Grey,
      text2: "${appSettings.customersCount}", style2: theme.style16W800Black,
      color: Colors.white, icon: "assets/dashboard2/cust.png",
      callback: (){print("button pressed");}, iconSize: 50, ));
  }

  _category(){
    return Expanded(child: Button186(text1: strings.get(158).toUpperCase(), /// "CATEGORY"
      style1: theme.style18W800Grey,
      text2: "${categories.length}", style2: theme.style16W800Black,
      color: Colors.white, icon: "assets/dashboard2/d4.png",
      callback: (){print("button pressed");}, iconSize: 50, ));
  }

  _service(){
    return Expanded(child: Button186(text1: strings.get(159).toUpperCase(), /// SERVICE
      style1: theme.style18W800Grey,
      text2: "${appSettings.serviceCount}", style2: theme.style16W800Black,
      color: Colors.white, icon: "assets/dashboard2/d3.png",
      callback: (){print("button pressed");}, iconSize: 50, ));
  }

  _chart2(){
    return Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
    ),
    padding: EdgeInsets.all(20),
    child: SfCartesianChart(
        title: ChartTitle(text: strings.get(160), /// 'Total Orders',
            textStyle: theme.style16W800Black),
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(
            width: 0,
          ),
        ),
        series: <ChartSeries>[
          // Renders column chart
          ColumnSeries<TotalData, String>(
              dataSource: _mainModel.booking.chartCount,
              width: 0.4,
              xValueMapper: (TotalData sales, _) => sales.year,
              yValueMapper: (TotalData sales, _) => sales.sales,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              pointColorMapper: (TotalData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(
                isVisible: false,
                // Positioning the data label
                useSeriesColor: true,
              )
          )
        ]
    ));
  }


}
