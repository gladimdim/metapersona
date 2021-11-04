import 'package:flutter/material.dart';
import 'package:metapersona/src/experience/experience.dart';
import 'package:timelines/timelines.dart';

class ExperiencePage extends StatelessWidget {
   static const String routeName = "/experience";
  const ExperiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professional Experience"),
      ),
      body: Timeline.tileBuilder(
        builder: TimelineTileBuilder.connected(
            contentsAlign: ContentsAlign.basic,
            itemCount: myExperience.length,
            indicatorBuilder: (context, index) => SizedBox(
              height: 110.0,
              child: TimelineNode(
                indicator: Card(
                  elevation: 10,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${myExperience[index].date.year}",
                      style:
                      Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                startConnector: index == 0
                    ? DashedLineConnector()
                    : SolidLineConnector(),
                endConnector: SolidLineConnector(),
              ),
            ),
            connectorBuilder: (context, index, type) =>
                SolidLineConnector(),
            oppositeContentsBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getTimelineNodeForCompany(index, context),
            ),
            contentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(myExperience[index].text),
              );
            }),
      ),
    );
  }


   _getTimelineNodeForCompany(int index, BuildContext context) {
     final company = myExperience[index].company;
     final nextDate = index == 0 ? DateTime.now() : myExperience[index - 1].date;
     final diff = nextDate.millisecondsSinceEpoch -
         myExperience[index].date.millisecondsSinceEpoch;
     final durationDiff = Duration(milliseconds: diff);
     return ConstrainedBox(
       constraints: const BoxConstraints(
         minWidth: 200,
       ),
       child: Card(
         elevation: 5,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(
               company.name,
               style: Theme.of(context).textTheme.headline6,
             ),
             Text(_timeDiffToString(durationDiff)),
           ],
         ),
       ),
     );
   }

   _timeDiffToString(Duration value) {
     var years = value.inDays ~/ 365;
     var months = value.inDays / 30;
     var monthsLeft = (months % 12).toInt();
     var yearLabel = years > 1 ? "years" : "year";
     var monthLabel = monthsLeft > 1 ? "months" : "month";
     var yearPrefix = years > 0 ? "${years.toInt()} $yearLabel" : "";
     var monthsPrefix = monthsLeft > 0 ? "$monthsLeft $monthLabel" : "";
     var joiner = (years > 0 && monthsLeft > 0) ? " and " : "";
     return "$yearPrefix$joiner$monthsPrefix";
   }
}
