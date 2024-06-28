import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StopwatchProvider(),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 0, 64, 57),
        ),
        home: const StopwatchScreen(),
      ),
    );
  }
}

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: stopwatchProvider.toggleAmbientMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cronómetro',
                style: TextStyle(
                  fontSize: 12.0,
                  color: stopwatchProvider.isAmbientMode ? Colors.grey[700] : Colors.tealAccent,
                ),
              ),
              const SizedBox(height: 5),
              Icon(
                Icons.timer,
                size: 30,
                color: stopwatchProvider.isAmbientMode ? Colors.grey[700] : Colors.tealAccent,
              ),
              const SizedBox(height: 5),
              Text(
                stopwatchProvider.timeFormatted,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: stopwatchProvider.isAmbientMode ? Colors.tealAccent : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: FloatingActionButton(
                      onPressed: () {
                        stopwatchProvider.start();
                        stopwatchProvider.setAmbientMode(true);
                      },
                      tooltip: 'Start',
                      backgroundColor: stopwatchProvider.isAmbientMode ? Colors.grey[900] : Colors.teal,
                      child: const Icon(Icons.play_arrow, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: FloatingActionButton(
                      onPressed: () {
                        stopwatchProvider.pause();
                        stopwatchProvider.setAmbientMode(false);
                      },
                      tooltip: 'Pause',
                      backgroundColor: stopwatchProvider.isAmbientMode ? Colors.grey[900] : Colors.teal,
                      child: const Icon(Icons.pause, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: FloatingActionButton(
                      onPressed: () {
                        stopwatchProvider.reset();
                        stopwatchProvider.setAmbientMode(false);
                      },
                      tooltip: 'Reset',
                      backgroundColor: stopwatchProvider.isAmbientMode ? Colors.grey[900] : Colors.teal,
                      child: const Icon(Icons.stop, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StopwatchProvider with ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  bool _isAmbientMode = false;

  String get timeFormatted {
    final duration = _stopwatch.elapsed;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
           '${(duration.inSeconds % 60).toString().padLeft(2, '0')}:'
           '${(duration.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
  }

  bool get isAmbientMode => _isAmbientMode;

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        notifyListeners();
      });
      setAmbientMode(true);  // Activar el modo ambiental cuando empieza
    }
  }

  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer.cancel();
      setAmbientMode(false);  // Desactivar el modo ambiental cuando pausa
    }
  }

  void reset() {
    _stopwatch.reset();
    notifyListeners();
    setAmbientMode(false);  // Desactivar el modo ambiental cuando resetea
  }

  void toggleAmbientMode() {
    _isAmbientMode = !_isAmbientMode;
    notifyListeners();
  }

  void setAmbientMode(bool isAmbient) {
    _isAmbientMode = isAmbient;
    notifyListeners();
  }
}
