import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_skills/Model/like.dart';
import 'package:team_skills/Model/person.dart';
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

  CollectionReference<Like> get likes =>
      _firebaseFirestore.collection('likes').withConverter(
          fromFirestore: ((snapshot, options) =>
              Like.fromJson(snapshot.data()!)),
          toFirestore: (like, _) => like.toJson());

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

  // Future<List<Skill>> getSkillsByUids(List<String> uids) async {
  //   var skillsList = <Skill>[];
  //   if (uids.isNotEmpty) {
  //     var snapshot = await skills.where('id', whereIn: uids).get();
  //   }
  //   return skillsList;
  // }

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
    await persons.doc(personID).update(person.toJson());
  }

  Future<Skill> getSkillByUid(String uid) async {
    var document = await skills.doc(uid).get();
    return document.data()!;
  }

  Future<String> addLike(String from, String skillId) async {
    DocumentReference<Like> collectionReference =
        await likes.add(Like(from: from, toSkill: skillId));
    return collectionReference.id;
  }

  Future<bool> isLiked(List<String>? likesIds, String personId) async {
    if (likesIds == null) {
      return false;
    } else {
      var data = await likes.where('from', isEqualTo: personId).get();
      bool isMatch = false;
      for (var element in data.docs) {
        isMatch = likesIds.contains(element.id);
      }
      return isMatch;
    }
  }

  Future<String?> deleteLike(List<String>? likesIds, String personId) async {
    var data = await likes.where('from', isEqualTo: personId).get();
    var snapshot = data.docs
        .firstWhere((element) => likesIds?.contains(element.id) ?? false);
    String? id;
    id = snapshot.id;
    await snapshot.reference.delete();
    return id;
  }

  // Future<void> migration(List<Person> persons) async {
  //   print('Migration called');
  //   print(persons.toString());
  //   var personsCollection = _firebaseFirestore
  //       .collection('persons')
  //       .withConverter<PersonNew>(
  //           fromFirestore: ((snapshot, options) =>
  //               PersonNew.fromJson(snapshot.data()!)),
  //           toFirestore: (person, _) => person.toJson());
  //
  //   for (Person person in persons) {
  //     PersonNew personNew = PersonNew(
  //         uid: person.uid,
  //         name: person.name,
  //         surname: person.surname,
  //         skills: person.skills != null
  //             ? List.generate(
  //                 person.skills!.length,
  //                 (index) =>
  //                     SkillHolder(skillId: person.skills!.keys.toList()[index]))
  //             : null);
  //     var querySnapshot =
  //         await personsCollection.where('uid', isEqualTo: person.uid).get();
  //     var personID = querySnapshot.docs[0].id;
  //     await personsCollection.doc(personID).update(personNew.toJson());
  //   }
  // }
}
