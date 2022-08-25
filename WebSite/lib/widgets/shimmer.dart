import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

rowCategory(double windowWidth, Animation<double> _animation){
  var _width = isMobile() ? windowWidth*0.35 : windowWidth * 0.8 /5-10;
  var _height = isMobile() ? windowWidth*0.35*0.5 : windowWidth * 0.8 /5 * 0.5;
  return Container(
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      oneShimmerItem(_width, _height, _animation),
      oneShimmerItem(_width, _height, _animation),
      if (!isMobile())
        oneShimmerItem(_width, _height, _animation),
      if (!isMobile())
        oneShimmerItem(_width, _height, _animation),
      if (!isMobile())
        oneShimmerItem(_width, _height, _animation),

  ],));
}

rowTopService(double windowWidth, Animation<double> _animation){
  double _width = windowWidth*0.4-20;
  double _height = 150;
  return Container(
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          oneShimmerItem(_width, _height, _animation),
          oneShimmerItem(_width, _height, _animation)
        ],));
}

oneProviderItem(double windowWidth, Animation<double> _animation){
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: oneShimmerItem(windowWidth*0.8/5-26, windowWidth*0.8/5-26, _animation),
  );
}
