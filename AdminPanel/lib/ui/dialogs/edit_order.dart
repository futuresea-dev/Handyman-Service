import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/elements/datetime.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class DialogEditOrder extends StatefulWidget {
  final Function() close;

  const DialogEditOrder({Key? key, required this.close,}) : super(key: key);

  @override
  _DialogEditOrderState createState() => _DialogEditOrderState();
}

class _DialogEditOrderState extends State<DialogEditOrder> {

  final _controllerAddress = TextEditingController();
  final _controllerComments = TextEditingController();
  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;

  String _status = "";
  String _address = "";
  String _comment = "";

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _status = currentOrder.status;
    _address = currentOrder.address;
    _comment = currentOrder.comment;
    _controllerAddress.text = _address;
    _controllerComments.text = _comment;
    super.initState();
  }

  @override
  void dispose() {
    _controllerAddress.dispose();
    _controllerComments.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

            InkWell(
              onTap: widget.close,
              child:
              Container(
                width: windowWidth,
                height: windowHeight,
                color: Colors.grey.withAlpha(50),
              ),
            ),


            Center(
                child: Container(
                  width: windowWidth*0.8,
                  // height: windowHeight*0.6,
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: _body()
                )
            )
          ],
        ));
  }

  _body(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10,),
        SelectableText("${strings.get(456)}: ${currentOrder.id}", style: theme.style14W400,), /// "Order ID",
        SizedBox(height: 10,),
        Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: textElement2(strings.get(97) + ":", "", _controllerAddress, (String val){  /// "Address",
              _address = val;
              _redraw();
            })),
            SizedBox(width: 20,),
            Expanded(child: textElement2(strings.get(180) + ":", "", _controllerComments, (String val){  /// "Comment",
              _comment = val;
              _redraw();
            })),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            SelectableText(strings.get(182), style: theme.style14W400,), /// "Status",
            Expanded(child: Container(
                child: Combo(inRow: true, text: "",
                  data: _mainModel.statusesCombo,
                  value: _status,
                  onChange: (String value){
                    _status = value;
                    _redraw();
                  },))),
            SizedBox(width: 30,),
            SelectableText(strings.get(183), style: theme.style14W400,), /// "Booking At",
            SizedBox(width: 10,),
            Expanded(child: Container(
              //width: 150,
              child: ElementSelectDateTime(
                getText: (){
                  return appSettings.getDateTimeString(currentOrder.selectTime);
                },
                setDateTime: (DateTime val) {
                  currentOrder.selectTime = val;
                  currentOrder.anyTime = false;
                  setState(() {
                  });
                },),
            )),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: button2b(strings.get(115), /// "Cancel",
                (){widget.close();},),),
            Expanded(child: Container(
                alignment: Alignment.centerRight,
                child: button2b(strings.get(9), _save) /// "Save",
            )
            ),
          ],
        )

      ],
    );
  }

  _save() async {
    currentOrder.status = _status;
    _mainModel.booking.setStatus(currentOrder);
    currentOrder.address = _address;
    currentOrder.comment = _comment;

    var ret = await saveBookingV2(currentOrder);
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    widget.close();
  }
}

