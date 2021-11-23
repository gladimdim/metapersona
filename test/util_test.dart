import 'package:flutter_test/flutter_test.dart';
import 'package:metapersona/src/utils.dart';
void main() {
  group('Markdown parser tests', () {
    test('Can get links', () {
      var input = "[Dima](http://google.com)";
      var result = getUrlLinksFromMarkdown(input);
      expect(result.length, equals(1), reason: "Found 1 link");

      input = "[]Maybe I found)";
      result = getUrlLinksFromMarkdown(input);
      expect(result.isEmpty, isTrue, reason: "No real links found");

      input = "[](Maybe I found";
      result = getUrlLinksFromMarkdown(input);
      expect(result.isEmpty, isTrue, reason: "No real links found");

      input = """
      [first](https://first)
      bla bla bla
      [second](https://second)
      ![some image](some.png)
      # lol hi
      [third](
      """;
      result = getUrlLinksFromMarkdown(input);
      expect(result.length, equals(3), reason: "Two links found");
      expect(result[0], equals("https://first"), reason: "First link found");
      expect(result[1], equals("https://second"), reason: "Second link found");
      expect(result[2], equals("some.png"), reason: "Second link found");
    });
  });
}
