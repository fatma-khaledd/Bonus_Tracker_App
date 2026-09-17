import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/theme/app_text_styles.dart';
import 'package:bonus_tracker_app/features/notes/cubit/notes_cubit.dart';
import 'package:bonus_tracker_app/features/notes/cubit/notes_state.dart';
import 'package:bonus_tracker_app/shared/models/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NoteDetailsScreen extends StatefulWidget {
  NoteModel? note;
  NoteDetailsScreen({super.key, this.note});
  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  DateTime now = DateTime.now();
  TextEditingController? content = TextEditingController();
  TextEditingController? title = TextEditingController();
  bool preview = false;
  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      title!.text = widget.note!.title;
      content!.text = widget.note!.content;
    }
  }

  List<dynamic> blocks = [];

  List<dynamic> parseBlocks(String text) {
    List<String> lines = text.split('\n');
    List<dynamic> result = [];
    for (var line in lines) {
      bool isTask =
          line.trimLeft().startsWith('- [ ]') ||
          line.trimLeft().startsWith('- [x]');
      if (isTask) {
        if (result.isNotEmpty && result.last is List<String>) {
          (result.last as List<String>).add(line);
        } else {
          result.add(<String>[line]);
        }
      } else {
        if (result.isNotEmpty && result.last is String) {
          result[result.length - 1] = (result.last as String) + '\n' + line;
        } else {
          result.add(line);
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    NotesCubit cubit = BlocProvider.of<NotesCubit>(context);
    return BlocBuilder<NotesCubit, NotesState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackground,
            leading: IconButton(
              onPressed: () {
                if (widget.note == null) {
                  cubit.addNote(
                    title: title!.text,
                    content: content!.text,
                    ownerId: FirebaseAuth.instance.currentUser?.uid,
                  );
                } else {
                  cubit.updateNote(
                    widget.note!.copyWith(
                      title: title!.text,
                      content: content!.text,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary.withAlpha(170),
              ),
            ),
          ),
          backgroundColor: AppColors.scaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 8, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 9,
              children: [
                Row(
                  children: [
                    !preview
                        ? Expanded(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: AppColors.textPrimary
                                      .withAlpha(30),
                                ),
                              ),
                              child: TextField(
                                controller: title,
                                style: AppTextStyles.logoTitle,
                                decoration: InputDecoration(
                                  fillColor: AppColors.scaffoldBackground,
                                  hint: Text(
                                    'Title...',

                                    style: TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 35,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.scaffoldBackground,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.scaffoldBackground,
                                    ),
                                  ),
                                ),
                                cursorColor: AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              title!.text,
                              style: AppTextStyles.logoTitle,
                            ),
                          ),

                    Column(
                      // spacing: 4,
                      children: [
                        Text(
                          'Preview',
                          style: TextStyle(
                            color: preview
                                ? AppColors.textHint
                                : AppColors.textSecondary,
                            fontSize: 14,
                            fontFamily:
                                GoogleFonts.playfairDisplay().fontFamily,
                          ),
                        ),
                        Switch(
                          trackOutlineColor: WidgetStatePropertyAll(
                            AppColors.textPrimary.withAlpha(70),
                          ),
                          inactiveTrackColor: AppColors.textPrimary.withAlpha(
                            30,
                          ),
                          activeThumbColor: AppColors.textHint,
                          hoverColor: AppColors.textPrimary.withAlpha(30),
                          thumbColor: WidgetStatePropertyAll(
                            AppColors.textPrimary,
                          ),
                          value: preview,
                          onChanged: (value) {
                            setState(() {
                              preview = value;
                              blocks = parseBlocks(content?.text ?? '');
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  style: TextStyle(
                    color: AppColors.textSecondary.withAlpha(200),
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(widget.note?.createdAt ?? DateTime.now()),
                ),
                !preview
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            selectionColor: AppColors.textPrimary.withAlpha(30),
                          ),
                        ),
                        child: TextField(
                          // style: AppTextStyles.heading1
                          style: TextStyle(
                            fontFamily:
                                GoogleFonts.playfairDisplay().fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            fillColor: AppColors.scaffoldBackground,

                            hint: Text(
                              'Write something...',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 20,
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.scaffoldBackground,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.scaffoldBackground,
                              ),
                            ),
                          ),
                          controller: content,
                          cursorColor: AppColors.textSecondary,
                        ),
                      )
                    : Expanded(
                        child: InkWell(
                          onDoubleTap: () => setState(() {
                            preview = false;
                          }),
                          child: ListView.builder(
                            itemCount: blocks.length,
                            itemBuilder: (context, index) {
                              var block = blocks[index];

                              if (block is List<String>) {
                                return Column(
                                  children: block.asMap().entries.map((entry) {
                                    int i = entry.key;
                                    String line = entry.value;
                                    bool checked = line.contains('[x]');
                                    String text = line
                                        .replaceFirst('- [ ] ', '')
                                        .replaceFirst('- [x] ', '');
                                    return CheckboxListTile(
                                      value: checked,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                          fontFamily:
                                              GoogleFonts.playfairDisplay()
                                                  .fontFamily,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          block[i] = value!
                                              ? '- [x] $text'
                                              : '- [ ] $text';
                                        });
                                      },
                                      checkColor: AppColors.scaffoldBackground,
                                      selectedTileColor:
                                          AppColors.darkSurfaceVariant,
                                      activeColor: AppColors.darkSurfaceVariant,
                                      hoverColor: AppColors.darkSurfaceVariant
                                          .withAlpha(30),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Markdown(
                                  data: block as String,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),

                                    h1: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                    h2: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                    h3: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                    h4: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                    strong: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                      fontFamily: GoogleFonts.playfairDisplay()
                                          .fontFamily,
                                    ),
                                    blockquote: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontFamily: GoogleFonts.jetBrainsMono()
                                          .fontFamily,
                                      color: AppColors.textPrimary,
                                    ),
                                    blockquoteDecoration: BoxDecoration(
                                      color: AppColors.textSecondary.withAlpha(
                                        30,
                                      ),
                                      // borderRadius: BorderRadius.circular(4),
                                    ),
                                    blockquotePadding: EdgeInsets.all(8),
                                    code: TextStyle(
                                      fontFamily: GoogleFonts.jetBrainsMono()
                                          .fontFamily,

                                      color: AppColors.textPrimary,
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: AppColors.textSecondary.withAlpha(
                                        30,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    codeblockPadding: EdgeInsets.all(10),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       edit = false;

                //       blocks = parseBlocks(content?.text ?? '');
                //     });
                //   },
                //   child: Text('Preview'),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 250),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     mainAxisAlignment: MainAxisAlignment.end,

                //     // spacing: 4,
                //     children: [
                //       Text(
                //         'Preview',
                //         style: TextStyle(
                //           color: edit
                //               ? AppColors.textHint
                //               : AppColors.textSecondary,
                //           fontSize: 14,
                //           fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                //         ),
                //       ),
                //       Switch(
                //         trackOutlineColor: WidgetStatePropertyAll(
                //           AppColors.textPrimary.withAlpha(70),
                //         ),
                //         inactiveTrackColor: AppColors.textPrimary.withAlpha(30),
                //         activeThumbColor: AppColors.textHint,
                //         hoverColor: AppColors.textPrimary.withAlpha(30),
                //         thumbColor: WidgetStatePropertyAll(AppColors.textPrimary),
                //         value: edit,
                //         onChanged: (value) {
                //           setState(() {
                //             edit = value;
                //             blocks = parseBlocks(content?.text ?? '');
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
