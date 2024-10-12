import 'dart:async';
import 'package:daily_todo_app/presentation/widgets/accelerometer_graph_card.dart';
import 'package:daily_todo_app/presentation/widgets/gyro_graph_card.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorTrackingPage extends StatefulWidget {
  const SensorTrackingPage({super.key});

  @override
  State<SensorTrackingPage> createState() => _SensorTrackingPageState();
}

class _SensorTrackingPageState extends State<SensorTrackingPage> {
  // Declare variables to store gyroscope data
  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;
  List<double> traceXvalue_gyro = [];
  List<double> traceYvalue_gyro = [];
  List<double> traceZvalue_gyro = [];

  // List to store accelerometer data
  List<AccelerometerEvent> _accelerometerValues = [];

  // StreamSubscription for accelerometer events
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  // oscilloscope chart vars for accelerometer
  List<double> traceXvalue = [];
  List<double> traceYvalue = [];
  List<double> traceZvalue = [];

  Timer? _timer;

  /// method to generate list for making graph
  _generateTrace(Timer t) {
    // generate our  values
    var xv = _accelerometerValues[0].x;
    var yv = _accelerometerValues[0].y;
    var zv = _accelerometerValues[0].z;
    // Add to the growing dataset
    setState(() {
      //to prevent memory overflow
      if (traceXvalue.length > 500) {
        traceXvalue.removeAt(0);
      }
      if (traceYvalue.length > 500) {
        traceYvalue.removeAt(0);
      }
      if (traceZvalue.length > 500) {
        traceZvalue.removeAt(0);
      }

      if (traceXvalue_gyro.length > 500) {
        traceXvalue_gyro.removeAt(0);
      }
      if (traceYvalue_gyro.length > 500) {
        traceYvalue_gyro.removeAt(0);
      }
      if (traceZvalue_gyro.length > 500) {
        traceZvalue_gyro.removeAt(0);
      }
      traceXvalue.add(xv);
      traceYvalue.add(yv);
      traceZvalue.add(zv);

      traceXvalue_gyro.add(_gyroX);
      traceYvalue_gyro.add(_gyroY);
      traceZvalue_gyro.add(_gyroZ);
    });
  }

  @override
  void initState() {
    super.initState();

    // Subscribe to accelerometer events
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      setState(() {
        // Update the _accelerometerValues list with the latest event
        _accelerometerValues = [event];
        _timer =
            Timer.periodic(const Duration(milliseconds: 30), _generateTrace);
      });
      // Listen to gyroscope data stream
      gyroscopeEventStream().listen((GyroscopeEvent event) {
        setState(() {
          _gyroX = event.x;
          _gyroY = event.y;
          _gyroZ = event.z;
        });
      });
    });
  }

  @override
  void dispose() {
    // Cancel the accelerometer event subscription to prevent memory leaks
    _accelerometerSubscription.cancel();
    // oc
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Sensor tracking page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Gyroscope Data:',
              style: TextStyle(fontSize: 20),
            ), // Display a label
            Text(
              'X: $_gyroX',
              style: const TextStyle(fontSize: 16),
            ), // Display gyroscope X data
            Text(
              'Y: $_gyroY',
              style: const TextStyle(fontSize: 16),
            ), // Display gyroscope Y data
            Text(
              'Z: $_gyroZ',
              style: const TextStyle(fontSize: 16),
            ), // Display gyroscope Z data
            Expanded(
              flex: 1,
              child: GyroGraphCard(
                traceXvalue: traceXvalue_gyro,
                traceYvalue: traceYvalue_gyro,
                traceZvalue: traceZvalue_gyro,
              ),
            ),

            const Text(
              'Accelerometer Data:',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),
            if (_accelerometerValues.isNotEmpty)
              Text(
                'X: ${_accelerometerValues[0].x.toStringAsFixed(2)}, '
                'Y: ${_accelerometerValues[0].y.toStringAsFixed(2)}, '
                'Z: ${_accelerometerValues[0].z.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text(
                'No data available',
                style: TextStyle(fontSize: 16),
              ),
            Expanded(
              flex: 1,
              child: AccelerometerGraphCard(
                traceXvalue: traceXvalue,
                traceYvalue: traceYvalue,
                traceZvalue: traceZvalue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
