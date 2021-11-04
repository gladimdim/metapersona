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