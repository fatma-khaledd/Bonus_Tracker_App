import 'package:bonus_tracker_app/shared/models/committee_model.dart';
import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
// + هنا هتعملي import للـ CommitteeModel لو مش متعمله import فوق

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  void loadHomeData() {
    emit(HomeLoading());
    try {
      final List<CommitteeModel> dummyCommittees = [
        CommitteeModel.fromMap({
          'name': 'لجنة التطوير',
          'createdAt': DateTime(2026, 9, 7, 12, 0, 0),
        }, id: 'committee_1'),

        CommitteeModel.fromMap({
          'name': 'لجنة التنظيم',
          'createdAt': DateTime(2026, 9, 7, 12, 0, 0),
        }, id: 'committee_2'),

        CommitteeModel.fromMap({
          'name': 'لجنة الميديا',
          'createdAt': DateTime(2026, 9, 7, 12, 0, 0),
        }, id: 'committee_3'),

        CommitteeModel.fromMap({
          'name': 'لجنة العلاقات العامة',
          'createdAt': DateTime(2026, 9, 7, 12, 0, 0),
        }, id: 'committee_4'),
      ];

      final List<MeetingModel> dummyMeetings = [
        MeetingModel(
          id: 'm1',
          title: 'اجتماع لمناقشة خطة العمل',
          description: 'مناقشة المهام والأهداف للفترة القادمة',
          date: DateTime(2026, 9, 14, 10, 0, 0),
          createdBy: 'admin_1',
          createdAt: DateTime(2026, 9, 14, 10, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 10, 0, 0),
          committeeId: 'committee_2',
        ),

        MeetingModel(
          id: 'm3',
          title: 'مراجعة المهام الأسبوعية',
          description: 'متابعة ما تم إنجازه من المهام',
          date: DateTime(2026, 9, 14, 10, 0, 0),
          createdBy: 'admin_1',
          createdAt: DateTime(2026, 9, 14, 11, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 10, 0, 0),
          committeeId: 'committee_1',
        ),
        MeetingModel(
          id: 'm2',
          title: 'بلا بلا بلا',
          description: 'متابعة ما تم إنجازه من المهام',
          date: DateTime(2026, 9, 14, 10, 0, 0),
          createdBy: 'admin_1',
          createdAt: DateTime(2026, 9, 14, 11, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 10, 0, 0),
          committeeId: 'committee_1',
        ),
      ];
      final List<EventModel> dummyEvents = [
        EventModel(
          id: 'e1',
          committeeId: 'committee_1', // مرتبطة بلجنة التطوير
          title: 'ورشة عمل فلاتر متقدمة',
          description:
              'شرح كيفية بناء تطبيقات متكاملة باستخدام Clean Architecture.',
          date: DateTime(2026, 9, 21, 15, 0, 0),
          createdBy: 'سارة عبد المنعم',
          createdAt: DateTime(2026, 9, 14, 10, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 11, 30, 0),
        ),
        EventModel(
          id: 'e2',
          committeeId: 'committee_2', // مرتبطة بلجنة التنظيم
          title: 'معسكر تدريبي لأعضاء التنظيم',
          description: 'شرح خطة إدارة الفعاليات والتعامل مع الحشود.',
          date: DateTime(2026, 9, 24, 11, 0, 0),
          createdBy: 'أحمد محمد',
          createdAt: DateTime(2026, 9, 14, 11, 30, 0),
          updatedAt: DateTime(2026, 9, 14, 11, 30, 0),
        ),
        EventModel(
          id: 'e3',
          committeeId: 'committee_3', // مرتبطة بلجنة الميديا
          title: 'جلسة تصوير ومونتاج',
          description: 'تجهيز المحتوى البصري الخاص بالأنشطة القادمة.',
          date: DateTime(2026, 9, 26, 13, 0, 0),
          createdBy: 'محمود خالد',
          createdAt: DateTime(2026, 9, 14, 12, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 12, 30, 0),
        ),
        EventModel(
          id: 'e4',
          committeeId: 'committee_4', // مرتبطة بلجنة العلاقات العامة
          title: 'اجتماع مع الرعاة والشركاء',
          description: 'مناقشة تفاصيل الدعم الخاص بالفعالية الكبرى.',
          date: DateTime(2026, 9, 30, 17, 0, 0),
          createdBy: 'سارة عبد المنعم',
          createdAt: DateTime(2026, 9, 14, 13, 0, 0),
          updatedAt: DateTime(2026, 9, 14, 11, 30, 0),
        ),
      ];

      emit(HomeLoaded(dummyCommittees, dummyMeetings, dummyEvents));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
