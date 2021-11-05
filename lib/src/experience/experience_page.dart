import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metapersona/src/experience/Position.dart';
import 'package:metapersona/src/utils.dart';
import 'package:timelines/timelines.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperiencePage extends StatelessWidget {
  static const String routeName = "/experience";

  const ExperiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewExperiencePage),
      ),
      body: FutureBuilder(
        future: _fetchExperience(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var json = snapshot.data as Map<String, dynamic>;
            var companyJson = json["companies"] as List;
            var positions = json["positions"] as List;
            List<Company> companies =
                companyJson.map((e) => Company.fromJson(e)).toList();
            List<Position> experiences = positions
                .map((e) => Position.fromJson(e, companies))
                .toList();
            return Timeline.tileBuilder(
              builder: TimelineTileBuilder.connected(
                  contentsAlign: ContentsAlign.basic,
                  itemCount: experiences.length,
                  indicatorBuilder: (context, index) => SizedBox(
                        height: 110.0,
                        child: TimelineNode(
                          indicator: Card(
                            elevation: 10,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${experiences[index].date.year}",
                                style: Theme.of(context).textTheme.headline6,
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
                        child: _getTimelineNodeForCompany(
                            index, experiences, context),
                      ),
                  contentsBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experiences[index].text,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            if (experiences[index].technologies != null) Text(
                              experiences[index].technologies!,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchExperience() async {
    final response = await http.get(
        Uri.parse("${getRootUrlPrefix()}profile/experience/experiences.json"));
    final body = response.body;
    return jsonDecode(body);
  }

  _getTimelineNodeForCompany(
      int index, List<Position> positions, BuildContext context) {
    final company = positions[index].company;
    final nextDate = index == 0 ? DateTime.now() : positions[index - 1].date;
    final diff = nextDate.millisecondsSinceEpoch -
        positions[index].date.millisecondsSinceEpoch;
    final durationDiff = Duration(milliseconds: diff);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
