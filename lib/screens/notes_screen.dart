import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/theme/app_text_styles.dart';
import 'package:bonus_tracker_app/core/widgets/floating_add_button.dart';
import 'package:bonus_tracker_app/core/widgets/note_card.dart';
import 'package:bonus_tracker_app/features/notes/cubit/notes_cubit.dart';
import 'package:bonus_tracker_app/features/notes/cubit/notes_state.dart';
import 'package:bonus_tracker_app/screens/note_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().loadNotes(
      uid: FirebaseAuth.instance.currentUser?.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: AppColors.scaffoldBackground),
          backgroundColor: AppColors.scaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text('Notes', style: AppTextStyles.sectionHeader),
                if (state.status == NotesStatus.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == NotesStatus.error)
                  Expanded(
                    child: Center(child: Text(state.errorMessage ?? 'حصل خطأ')),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                        right: 15,
                        left: 15,
                        top: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final note = state.notes[index];

                        return NoteCard(
                          content: note.content,
                          date: DateFormat(
                            'dd MMM yyyy',
                          ).format(note.createdAt),
                          title: note.title,
                          isDone: note.isDone,
                          onDoneChanged: (value) {
                            context.read<NotesCubit>().toggleNoteDone(
                              noteId: note.id,
                              isDone: value ?? false,
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoteDetailsScreen(note: note),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: state.notes.length,
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteDetailsScreen()),
              );
            },
          ),
        );
      },
    );
  }
}
