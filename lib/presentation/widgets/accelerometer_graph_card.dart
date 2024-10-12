import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

class AccelerometerGraphCard extends StatelessWidget {
  List<double> traceXvalue = [];
  List<double> traceYvalue = [];
  List<double> traceZvalue = [];

  AccelerometerGraphCard({
    required this.traceXvalue,
    required this.traceYvalue,
    required this.traceZvalue,
  });

  @override
  Widget build(BuildContext context) {
    // Create A Scope Display for X
    Oscilloscope scopeX = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.black,
      margin: EdgeInsets.all(20.0),
      strokeWidth: 3.0,
      backgroundColor: Colors.white,
      traceColor: Colors.green,
      yAxisMax: 10.0,
      yAxisMin: -3.0,
      // dataSet: traceSine,
      dataSet: traceXvalue,
    );
    // Create A Scope Display for Y
    Oscilloscope scopeY = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.black,
      margin: EdgeInsets.all(20.0),
      strokeWidth: 3.0,
      backgroundColor: Colors.white.withOpacity(0),
      traceColor: Colors.yellow,
      yAxisMax: 10.0,
      yAxisMin: -3.0,
      dataSet: traceYvalue,
    );
    // Create A Scope Display for Z
    Oscilloscope scopeZ = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.black,
      margin: EdgeInsets.all(20.0),
      strokeWidth: 3.0,
      backgroundColor: Colors.white.withOpacity(0),
      traceColor: Colors.red,
      yAxisMax: 10.0,
      yAxisMin: -3.0,
      dataSet: traceZvalue,
    );
    return Card(
      child: Stack(
        children: [
          scopeX,
          scopeY,
          scopeZ,
        ],
      ),
    );
  }
}
