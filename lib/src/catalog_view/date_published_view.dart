import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePublishedView extends StatelessWidget {
  final DateTime date;

  DatePublishedView({Key? key, required this.date}) : super(key: key);
  final DateFormat format = DateFormat("yyyy-MM");
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${AppLocalizations.of(context)!.labelPublishedOn}: ",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          format.format(date),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
