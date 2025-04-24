import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mood_cat/core/const/strings.dart';
import 'package:mood_cat/features/mood_content/data/models/mood/mood_data.dart';
import 'package:mood_cat/features/mood_content/data/models/mood_by_day/mood_by_day.dart';
import 'package:mood_cat/utils/app_utils.dart';
import 'package:mood_cat/utils/mood_util.dart';

part 'mood_content_event.dart';
part 'mood_content_state.dart';

@injectable
class MoodContentBloc extends Bloc<MoodContentEvent, MoodContentState> {
  MoodContentBloc() : super(MoodContentInitial()) {
    on<SaveMoodEvent>(_onSaveMood);
    on<FetchMoodListEvent>(_onFetchMoodList);
  }

  Future<void> _onSaveMood(
      SaveMoodEvent event, Emitter<MoodContentState> emit) async {
    emit(MoodContentLoading());

    try {
      // 1. Lấy thông tin người dùng từ AppUtils.getCurrentUser()
      final userData = AppUtils.getCurrentUser();
      if (userData == null) return;

// 2. Chuẩn hóa ngày: chỉ lấy ngày/tháng/năm
      final selectedDay = DateTime(
        event.selectedDay.year,
        event.selectedDay.month,
        event.selectedDay.day,
      ); // Đặt giờ, phút, giây về 0
      final createdAtMillis = selectedDay.millisecondsSinceEpoch;

      // 3. Tải lên các file ảnh
      final cloudinary = CloudinaryPublic(
        Strings.CLOUDINARY_CLOUD_NAME,
        Strings.CLOUDINARY_UPLOAD_PRESET,
        cache: false,
      );

      final List<String> imageUrls = [];
      for (final file in event.images) {
        if (!await file.exists()) {
          throw Exception('File does not exist: ${file.path}');
        }
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file.path,
              resourceType: CloudinaryResourceType.Image),
        );
        imageUrls.add(response.secureUrl);
      }

      // 4. Tạo dữ liệu cho document
      MoodData moodData = MoodData(
        mood: event.mood.name,
        content: event.content,
        imageUrls: imageUrls,
        user: userData,
        createdAt: createdAtMillis,
      );

      // 5. Kiểm tra xem đã có document nào với cùng ngày chưa
      QuerySnapshot existingDocs = await FirebaseFirestore.instance
          .collection('mood')
          .where('createdAt', isEqualTo: createdAtMillis)
          .get();

      String docId;
      if (existingDocs.docs.isNotEmpty) {
        // Nếu đã tồn tại document với ngày này, cập nhật document đó
        docId = existingDocs.docs.first.id;
        await FirebaseFirestore.instance
            .collection('mood')
            .doc(docId)
            .update(moodData.toJson());
      } else {
        // Nếu chưa tồn tại, tạo mới document
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('mood')
            .add(moodData.toJson());
        docId = docRef.id;
      }

      emit(MoodContentSaved(docId));
    } catch (e) {
      emit(MoodContentError('Lỗi khi lưu dữ liệu: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoodList(
      FetchMoodListEvent event, Emitter<MoodContentState> emit) async {
    emit(MoodContentLoading());

    try {
      List<MoodByDay> moodByDayList = [];

      // 1. Lấy danh sách từ Firestore collection 'mood'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('mood').get();

      // 2. Chuyển đổi danh sách document thành List<MoodData>
      final moodList = querySnapshot.docs.map((doc) {
        return MoodData.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      moodByDayList = moodList.map((moodData) {
        var fullDate = DateTime.fromMillisecondsSinceEpoch(moodData.createdAt);

        return MoodByDay(
          mood: stringToMood(moodData.mood),
          date: DateTime(fullDate.year, fullDate.month, fullDate.day),
        );
      }).toList();

      emit(MoodContentListLoaded(moodByDayList));
    } catch (e) {
      emit(MoodContentError('Lỗi khi lấy danh sách: ${e.toString()}'));
    }
  }
}
