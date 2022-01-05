import 'dart:convert';

import 'package:http/http.dart' as http;

class Profile {
  static const String profileRoot = "/profile";
  static String get profilePath => "$profileRoot/profile.json";
  final String firstName;
  final String lastName;
  final String avatarFileName;

  String get avatarPath => "$profileRoot/$avatarFileName";

  const Profile({required this.firstName, required this.lastName, required this.avatarFileName});

  static fromJson(Map<String, dynamic> input) {
    return Profile(firstName: input["firstName"], lastName: input["lastName"], avatarFileName: input["avatarFileName"]);
  }
}

class MetaPersona {
  final String fullPath;
  final Profile profile;

  String get fullName => "${profile.firstName} ${profile.lastName}";

  const MetaPersona(this.fullPath, {required this.profile});

  String get fullAvatarPath => "$fullPath/${profile.avatarPath}";

  static Future<MetaPersona> initFromUrl(String fullPath) async {
    var profileResponse =
        await http.get(Uri.parse(fullPath + Profile.profilePath));
    var profileBody = jsonDecode(profileResponse.body);
    Profile profile = Profile.fromJson(profileBody);

    return MetaPersona(fullPath, profile: profile);
  }
}
