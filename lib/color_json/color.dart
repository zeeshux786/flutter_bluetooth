import 'package:flutter/widgets.dart';

class ColorModels {
  final String name;
  final Color color_id;


  ColorModels({this.name, this.color_id});
}

List<ColorModels> dummyData = [
  new ColorModels(
      name: "red",
      color_id: Color(0xfff44336),
    
  ),
  new ColorModels(
      name: "Harvey Spectre",
       color_id: Color(0xfff44336),
  ),
  new ColorModels(
      name: "Mike Ross",
      color_id: Color(0xfff44336),
     ),
  new ColorModels(
      name: "Rachel",
       color_id: Color(0xfff44336),
   
  ),
  new ColorModels(
      name: "Barry Allen",
       color_id: Color(0xfff44336),
     ),
  new ColorModels(
      name: "Joe West",
       color_id: Color(0xfff44336),
     ),
];
