import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:two_covid_tracker/Services/states_services.dart';
import 'package:two_covid_tracker/view/countries_list.dart';

import '../Model/World_state_model.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorLists = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /*SizedBox(
              height: MediaQuery.of(context).size.height * 01,
            ),*/
              FutureBuilder(
                future: stateServices.fetchWorkedStatesRecords(),
                builder: (context, AsyncSnapshot<World_states_model> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total":
                                double.parse(snapshot.data!.cases.toString()),
                            "Recoverage": double.parse(
                                snapshot.data!.recovered.toString()),
                            "Deaths":
                                double.parse(snapshot.data!.deaths.toString()),
                          },
                          chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: const Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorLists,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.06),
                          child: Card(
                              child: Column(
                            children: [
                              ReusableRow(
                                  title: "Total",
                                  value: snapshot.data!.cases.toString()),
                              ReusableRow(
                                  title: "Deaths",
                                  value: snapshot.data!.deaths.toString()),
                              ReusableRow(
                                  title: "Recovered",
                                  value: snapshot.data!.recovered.toString()),
                              ReusableRow(
                                  title: "Active",
                                  value: snapshot.data!.active.toString()),
                              ReusableRow(
                                  title: "Critical",
                                  value: snapshot.data!.critical.toString()),
                              ReusableRow(
                                  title: "Today Deaths",
                                  value: snapshot.data!.todayDeaths.toString()),
                              ReusableRow(
                                  title: "Today Recovered",
                                  value: snapshot.data!.todayRecovered.toString())
                            ],
                          )),
                        ),

                        /*SizedBox(
                            height: 20,
                          ),*/
                        // Padding(
                        //padding: EdgeInsets.symmetric(
                        // vertical: MediaQuery.of(context).size.height * 06)),

                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Countries_list_Screen()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 71, 211, 144),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('Track Countries')),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
