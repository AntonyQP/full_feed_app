import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/illness_list_view_model.dart';
import 'package:full_feed_app/view_model/illness_view_model.dart';
import 'package:grouped_buttons_ns/grouped_buttons_ns.dart';
import 'package:provider/provider.dart';

class UserIllnessesScreen extends StatefulWidget {
  final Function goToNextPage;
  const UserIllnessesScreen({required this.goToNextPage, Key? key}) : super(key: key);

  @override
  State<UserIllnessesScreen> createState() => _UserIllnessesScreenState();
}

class _UserIllnessesScreenState extends State<UserIllnessesScreen> {

  late var _future;

  List<String> selectedIllnesses = [];

  List<IllnessViewModel> registerIllnesses = [];

  @override
  void initState() {
    _future = Provider.of<IllnessListViewModel>(context, listen: false).populateIllnessesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {

        final illnessesList = Provider.of<IllnessListViewModel>(context, listen: false).getIllnesses();

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  dense: true,
                  child: ExpansionTile(
                    maintainState: true,
                    iconColor: mealCheckColor,
                    textColor: Colors.black54,
                    title: const Text('Enfermedades', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    children: [
                      CheckboxGroup(
                        labels: illnessesList.map((e) => e.name!).toList(),
                        onSelected: (List<String> selected) {
                          setState(() {
                            selectedIllnesses = selected;
                          });
                        },
                        activeColor: itemSelectedColor,
                      ),
                    ],
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  for(var selectedItem in selectedIllnesses) {
                    for(var illness in illnessesList) {
                      if(selectedItem == illness.name) {
                        registerIllnesses.add(illness);
                      }
                    }
                  }
                  await Provider.of<IllnessListViewModel>(context, listen: false).setPatientIllnesses(registerIllnesses).whenComplete(() {
                    Provider.of<IllnessListViewModel>(context, listen: false).registerPatientIllnesses().then((value){
                      if(value){
                        widget.goToNextPage();
                      }
                    });
                  });
                },
                elevation: 1,
                child: Ink(
                  width: 200,
                  height: 200,
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          stops: [0.05, 1]
                      )
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 25),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
