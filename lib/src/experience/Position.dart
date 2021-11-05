class Position {
  final DateTime date;
  final String text;
  final Company company;
  String? subText;
  String? technologies;

  Position(
      {required this.date,
      required this.text,
      required this.company,
        this.technologies,
      this.subText});

  static Position fromJson(
      Map<String, dynamic> input, List<Company> withCompanies) {
    final companyName = input["company"];
    final company = withCompanies.firstWhere((e) => e.name == companyName, orElse: () => Company(name: "No_Name"));
    final date = DateTime.parse(input["date"]);
    return Position(
      date: date,
      text: input["text"],
      company: company,
      subText: input["subText"],
      technologies: input["technologies"],
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