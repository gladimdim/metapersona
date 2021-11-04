class Experience {
  final DateTime date;
  final String text;
  final Company company;
  String? subText;

  Experience(
      {required this.date,
      required this.text,
      required this.company,
      this.subText});

  static Experience fromJson(
      Map<String, dynamic> input, List<Company> withCompanies) {
    final companyName = input["company"];
    final company = withCompanies.firstWhere((e) => e.name == companyName, orElse: () => Company(name: "No_Name"));
    final date = DateTime.parse(input["date"]);
    return Experience(
      date: date,
      text: input["text"],
      company: company,
      subText: input["subText"],
    );
  }
}

class Company {
  final String name;
  String? imageUrl;

  Company({required this.name, this.imageUrl});

  static Company fromJson(Map<String, dynamic> input) {
    return Company(name: input["name"], imageUrl: input["imageUrl"]);
  }
}

final sap = Company(name: "SAP");
final globalLogic = Company(name: "GlobalLogic");
final visiprise = Company(name: "Visiprise");
final zoomdata = Company(name: "Zoomdata");

List<Experience> myExperience = [
  Experience(
      date: DateTime(2018, 12), text: "Senior Software Engineer", company: sap),
  Experience(
      date: DateTime(2015, 12),
      text: "Senior JavaScript Developer",
      company: zoomdata),
  Experience(
      date: DateTime(2015, 6), text: "Development Team Lead", company: sap),
  Experience(date: DateTime(2013, 5), text: "Software Developer", company: sap),
  Experience(
      date: DateTime(2012, 4),
      text: "Senior Software Test Engineer",
      company: sap),
  Experience(
      date: DateTime(2008, 10), text: "Software Test Engineer", company: sap),
  Experience(
      date: DateTime(2007, 12),
      text: "Software Test Engineer at Visiprise (bought by SAP)",
      company: visiprise),
  Experience(
      date: DateTime(2006, 6),
      text: "Software Test Engineer",
      company: globalLogic),
];
