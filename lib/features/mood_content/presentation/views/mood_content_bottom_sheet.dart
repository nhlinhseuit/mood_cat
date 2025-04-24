import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_cat/core/bloc/base_page_state.dart';
import 'package:mood_cat/features/home_expense/widget/date_picker.dart';
import 'package:mood_cat/features/home_expense/widget/mood_select_only_bottom_sheet.dart';
import 'package:mood_cat/features/mood_content/presentation/bloc/mood_content_bloc.dart';
import 'package:mood_cat/utils/app_utils.dart';
import 'package:mood_cat/utils/mood_util.dart';
import 'dart:io';

class MoodContentBottomSheet extends StatefulWidget {
  final DateTime selectedDay;
  final Mood mood;

  const MoodContentBottomSheet({
    super.key,
    required this.selectedDay,
    required this.mood,
  });

  @override
  State<MoodContentBottomSheet> createState() => _MoodContentBottomSheetState();
}

class _MoodContentBottomSheetState
    extends BasePageState<MoodContentBottomSheet, MoodContentBloc> {
  late DateTime _selectedDay;
  late Mood _mood;
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _mood = widget.mood;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }

  void _showDatePicker(BuildContext context) async {
    var selectedDate = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DatePickerBottomSheet(
          initialDate: _selectedDay,
          onDateSelected: (DateTime newDate) {
            setState(() {
              _selectedDay = newDate;
            });
          },
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDay = selectedDate;
      });
    }
  }

  void _onIconSelected() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const MoodSelectionOnlyBottomSheet();
      },
    ).then((mood) {
      if (mood != null) {
        setState(() {
          _mood = mood;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<MoodContentBloc, MoodContentState>(
      builder: (context, state) {
        if (state is MoodContentSaved) {
          Navigator.of(context).pop(state.documentId);
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF202A35),
              child: Stack(
                children: [
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Container(
                      color: const Color(0xFF202A35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: _pickImage,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  bloc.add(
                                    SaveMoodEvent(
                                      selectedDay: _selectedDay,
                                      mood: _mood,
                                      content: _contentController.text,
                                      images: _selectedImages,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text(
                                  'Lưu',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 72.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _showDatePicker(context),
                            child: Text(
                              AppUtils.formatDateToVietnamese(_selectedDay),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          GestureDetector(
                            onTap: _onIconSelected,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _mood.color,
                              ),
                              child: Center(
                                child: Text(
                                  _mood.emoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            _mood.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                _formatTime(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                width: 50,
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          if (_selectedImages.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: List.generate(
                                  _selectedImages.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                            child: Image.file(
                                              _selectedImages[index],
                                              width: 400,
                                              height: 400,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12.0,
                                          right: 12.0,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                onPressed: () =>
                                                    _removeImage(index),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _contentController,
                                    minLines: 2,
                                    maxLines: 2,
                                    textAlignVertical: TextAlignVertical.top,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Nhập nội dung của em bé...',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
