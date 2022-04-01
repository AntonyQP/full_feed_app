import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../util/colors.dart';

class BMIScreen extends StatefulWidget {
  final VoidCallback goToNexPage;
  const BMIScreen({Key? key, required this.goToNexPage}) : super(key: key);

  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  Color _colorEgg = lowWeightColor;
  double _valueSlider = 5.0;
  String _labelEgg = "BAJO PESO";
  String value = "";
  Timer? timer;

  @override
  void initState() {
    Provider.of<RegisterViewModel>(context, listen: false).calculateImc();
    super.initState();
    showValue();
  }

  @override
  dispose(){
    timer!.cancel();
    super.dispose();
  }

  showValue(){
    // timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
    //   if(_valueSlider < Provider.of<RegisterViewModel>(context, listen: false).getImc()){
    //     setState(() {
    //       _valueSlider += 0.1;
    //       if (_valueSlider >= 30.0) {
    //         _colorEgg = fatWeightColor;
    //         _labelEgg = "OBESIDAD";
    //       }
    //       if (_valueSlider < 30.0 && _valueSlider >= 25.0) {
    //         _colorEgg = overWeightColor;
    //         _labelEgg = "SOBREPESO";
    //       }
    //       if (_valueSlider < 24.9 && _valueSlider >= 18.5) {
    //         _colorEgg = normalWeightColor;
    //         _labelEgg = "NORMAL";
    //       }
    //       if (_valueSlider < 18.5) {
    //         _colorEgg = lowWeightColor;
    //         _labelEgg = "BAJO PESO";
    //       }
    //       value = _valueSlider.toStringAsFixed(1);
    //     });
    //   }
    // });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    super.build(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
                ClipPath(
                  clipper: Egg(
                      screenWidth: MediaQuery.of(context).size.width,
                      screenHeight: MediaQuery.of(context).size.height),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: _colorEgg,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.16,
              top: MediaQuery.of(context).size.height * 0.42,
                child: Container(
                  color: _colorEgg,
                  height: MediaQuery.of(context).size.height/150,
                  width: MediaQuery.of(context).size.width/1.6,
                ),),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.10,
              top: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.75,
              child: SfSlider(
                thumbShape: const SfThumbShape(),
                min: 5.0,
                max: 45.0,
                value: _valueSlider,
                interval: 2,
                showTicks: true,
                activeColor: Colors.white,
                inactiveColor: Colors.transparent,
                enableTooltip: false,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {

                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07,
              left: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                "Tu IMC actual es",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.06,
              child: Center(
                child: Text(
                  _labelEgg,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: AnimatedSwitcher(
                  duration: Duration(seconds: 10),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height/6.5),
        FloatingActionButton(
          onPressed: widget.goToNexPage,
          elevation: 1,
          child: Ink(
            width: 200,
            height: 200,
            decoration: const ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                    colors: [primaryColor, Color(0xFFFF9FC8)],
                    stops: [0.05, 1]
                )
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 25),
          ),
        )
      ],
    );
  }
}

class Egg extends CustomClipper<Path> {

  double screenWidth, screenHeight;
  Egg({required this.screenWidth, required this.screenHeight});
  @override
  Path getClip(Size size) {
    var path = Path();
    var rectTop = Rect.fromLTRB(screenWidth * 0.15, screenHeight * 0.21,
        screenWidth * 0.80, screenHeight * 0.63);
    var rectBottom = Rect.fromLTRB(screenWidth * 0.15, screenHeight * 0.27,
        screenWidth * 0.80, screenHeight * 0.58);
    path.addArc(rectBottom, 0, pi);
    path.addArc(rectTop, pi, pi);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


