import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  final Set<String> languages;
  final Function(Set<String>) onSelected;

  const LanguageSelector(
      {Key? key, required this.languages, required this.onSelected})
      : super(key: key);

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    selected = widget.languages.toSet();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.languages);
    print(selected);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.languages
          .map((e) => Row(
                children: [
                  Text(e),
                  Checkbox(
                    onChanged: (value) => _onSelected(e, value),
                    value: selected.contains(e),
                  ),
                ],
              ))
          .toList(),
    );
  }

  _onSelected(String language, bool? value) {
    if (value == null) {
      selected.remove(language);
    } else if (value) {
      selected.add(language);
    } else if (!value) {
      selected.remove(language);
    }
    setState(() {});
    widget.onSelected(selected);
  }
}
