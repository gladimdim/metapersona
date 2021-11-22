import 'package:flutter/material.dart';
import 'package:metapersona/src/components/search_box.dart';

class ListSearchRefreshView extends StatelessWidget {
  final VoidCallback onRefreshDataPressed;
  final Function(String) onTextSearch;

  const ListSearchRefreshView(
      {Key? key,
      required this.onRefreshDataPressed,
      required this.onTextSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: SearchBox(
              onSearchChange: onTextSearch,
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: onRefreshDataPressed,
          )
        ],
      ),
    );
  }
}
