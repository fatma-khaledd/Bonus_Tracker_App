import 'dart:developer';

import 'package:bonus_tracker_app/features/members/cubit/states.dart';
import 'package:bonus_tracker_app/shared/models/models.dart';
import 'package:bonus_tracker_app/shared/repositories/members/firestore_members_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(IntialState());
  static MemberCubit get(BuildContext context) => BlocProvider.of(context);
  List<MemberModel> members = [];

  Future<void> getAllMemebers() async {
    emit(GetMemberLoadingState());
    try {
      final result = await FirestoreMembersRepository().getMembersList(
        'committee_test',
      );

      log('💗Members count: ${result.length}');

      // log(result);

      members = result;
      emit(GetMemberSuccessState());
    } catch (e, s) {
      print(e);
      print(s);
      emit(GetMemberErrorState());
    }
  }

  //====================
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late String selectedMonth = 'July';

  void selectMonth(String month) {
    emit(GetMonthLoadingState());
    selectedMonth = month;
    emit(GetMonthSuccessState());
  }

  //====================================
  List<MemberModel> filter(
    List<MemberModel> members,
    List<MonthlyStatsModel> state,
    String month,
  ) {
    emit(FilterLoadingState());
    try {
      // state.sort(
      //   (a, b) => (b.scorePercent.toDouble() / 100).compareTo(
      //     a.scorePercent.toDouble() / 100,
      //   ),
      // );
      List<String> filteredMembersIds = [];
      List<MemberModel> filteredMembers = [];
      for (var i in state) {
        final date = DateTime.parse('${i.monthKey}-01');
        final monthName = DateFormat('MMMM').format(date);
        if (monthName == month) {
          filteredMembersIds.add(i.memberId!);
        }
      }
      for (var i in filteredMembersIds) {
        for (var mem in members) {
          if (mem.userId == i) {
            filteredMembers.add(mem);
          }
        }
      }
      emit(FilterMemberSuccessState());
      return filteredMembers;
    } catch (e, s) {
      print(e);
      print(s);
      emit(FilterMemberErrorState());
      return [];
    }
  }
}
