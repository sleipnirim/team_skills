import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_skills/Model/skill.dart';

import 'Model/person.dart';

class StorageController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference<Person> get persons =>
      _firebaseFirestore.collection('persons').withConverter<Person>(
          fromFirestore: ((snapshot, options) =>
              Person.fromJson(snapshot.data()!)),
          toFirestore: (person, _) => person.toJson());

  CollectionReference<Skill> get skills =>
      _firebaseFirestore.collection('skills').withConverter<Skill>(
          fromFirestore: ((snapshot, options) =>
              Skill.fromJson(snapshot.data()!)),
          toFirestore: (skill, _) => skill.toJson());

  Future<bool> checkIfPersonExists(String uid) async {
    bool userExists = false;
    await _firebaseFirestore
        .collection('persons')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userExists = true;
      } else {
        userExists = false;
      }
    });
    return userExists;
  }

  Future<Person?> getPerson(String uid) async {
    var querySnapshot = await persons.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs[0].data();
  }

  List<Skill> getSkillsByUids(List<String> uids) {
    var skillsList = <Skill>[];
    if (uids.isNotEmpty) {
      skills
          .where('uid', whereIn: uids)
          .get()
          .then((value) => value.docs.map((e) => skills.add(e.data())));
    }
    return skillsList;
  }

  Future<Iterable<Skill>> getSkillForAutocomplete(
      String pattern, SkillType type) async {
    var skillsList = <Skill>[];
    var querySnapshot = await skills.where('type', isEqualTo: type.name).get();
    skillsList = querySnapshot.docs.map((e) => e.data()).toList();
    return skillsList.where((element) =>
        element.name.toLowerCase().startsWith(pattern.toLowerCase()));
  }

  Future<String> getSkillId(String name, SkillType type) async {
    var querySnapshot = await skills.where("name", isEqualTo: name).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .firstWhere((element) => element.data().type == type)
          .id;
    } else {
      var document = await skills.add(Skill(name: name, type: type));
      return document.id;
    }
  }

  Future<void> addPerson(Person person) async {
    await persons.add(person);
  }

  Future<void> updatePerson(Person person) async {
    var querySnapshot = await persons.where('uid', isEqualTo: person.uid).get();
    var personID = querySnapshot.docs[0].id;
    persons.doc(personID).update(person.toJson());
  }

  Future<Skill> getSkillByUid(String uid) async {
    var document = await skills.doc(uid).get();
    return document.data()!;
  }
}
