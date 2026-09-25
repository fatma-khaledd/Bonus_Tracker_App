import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bonus_tracker_app/core/constants/firestore_paths.dart';
import 'package:bonus_tracker_app/shared/models/committee_model.dart';
import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/member_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';
import 'package:bonus_tracker_app/shared/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  int selectedIndex = 0;

  HomeCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw StateError('You must be signed in to load home data.');
      }

      final userSnapshot =
          await _firestore.doc(FirestorePaths.user(currentUser.uid)).get();
      final userData = userSnapshot.data();
      if (userData == null) {
        throw StateError('Your user profile was not found in Firestore.');
      }
      final user = UserModel.fromMap(userData, uid: currentUser.uid);

      final committeeId = user.defaultCommitteeId;
      if (committeeId == null || !user.committees.contains(committeeId)) {
        throw StateError(
          'Set defaultCommitteeId to one of your committee IDs in your user profile.',
        );
      }

      final committeeSnapshot =
          await _firestore.doc(FirestorePaths.committee(committeeId)).get();
      final committeeData = committeeSnapshot.data();
      if (!committeeSnapshot.exists || committeeData == null) {
        throw StateError('The selected committee was not found.');
      }
      final committee =
          CommitteeModel.fromMap(committeeData, id: committeeSnapshot.id);
      selectedIndex = 0;

      final snapshots = await Future.wait([
        _firestore.collection(FirestorePaths.meetings(committee.id)).get(),
        _firestore.collection(FirestorePaths.events(committee.id)).get(),
      ]);
      final memberSnapshot = await _firestore
          .doc(FirestorePaths.member(committee.id, currentUser.uid))
          .get();
      final memberData = memberSnapshot.data();
      final stats = memberData == null
          ? null
          : MemberStats.fromMap(
              memberData['stats'] as Map<String, dynamic>?,
            );
      final meetings = snapshots[0].docs
          .map((doc) => MeetingModel.fromMap(
                doc.data(),
                id: doc.id,
                committeeId: committee.id,
              ))
          .toList();
      final events = snapshots[1].docs
          .map((doc) => EventModel.fromMap(
                doc.data(),
                id: doc.id,
                committeeId: committee.id,
              ))
          .toList();
      final memberStatsByCommitteeId = {
        if (stats != null) committee.id: stats,
      };

      emit(
        HomeLoaded(
          [committee],
          meetings,
          events,
          memberStatsByCommitteeId: memberStatsByCommitteeId,
          selectedIndex: selectedIndex,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void changeCommittee(int newIndex) {
    selectedIndex = newIndex;
    emit((state as HomeLoaded).copyWith(selectedIndex: selectedIndex));
  }
}
