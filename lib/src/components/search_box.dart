import 'package:flutter/material.dart';
import 'dart:async';

class SearchBox extends StatefulWidget {
  const SearchBox(
      {Key? key,
      required this.onSearchChange,
      this.throttleDuration = const Duration(milliseconds: 250)})
      : super(key: key);
  final Function(String text) onSearchChange;
  final Duration throttleDuration;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _dispatchCallbackTimer;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_textChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
            ),
            controller: _textEditingController,
          ),
        ),
        IconButton(onPressed: _clearText, icon: const Icon(Icons.clear)),
      ],
    );
  }

  void _textChanged() {
    _dispatchCallbackTimer?.cancel();
    _dispatchCallbackTimer = Timer(widget.throttleDuration, _sendCallback);
  }

  void _sendCallback() {
    widget.onSearchChange(_textEditingController.text);
  }

  void _clearText() {
    setState(() {
      _textEditingController.text = "";
    });
  }
}
