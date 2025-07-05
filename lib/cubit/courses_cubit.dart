import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadrib_hub/controller/end_point.dart';
import 'package:tadrib_hub/cubit/courses_state.dart';
import 'package:tadrib_hub/models/Courses_Model.dart';
import 'package:dio/dio.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(InitialState());

  static CoursesCubit get(context) => BlocProvider.of(context);

  final Dio _dio = Dio();

  // قائمة للاحتفاظ بالكورسات المحملة
  List<Courses> _courses = [];
  List<Courses> get courses => _courses;

  void getCourses() async {
    emit(LoadingCourses());

    try {
      final response = await _dio.get('https://elearnbackend-production.up.railway.app/api/courses');

      if (response.statusCode == 200) {
        final coursesModel = CoursesModel.fromJson(response.data);

        if (coursesModel.success == true && coursesModel.courses != null) {
          _courses = coursesModel.courses!;
          emit(SuccessCourses(_courses));
        } else {
          emit(ErrorCourses('Failed to load courses: No data available'));
        }
      } else {
        emit(ErrorCourses('Server error: ${response.statusCode}'));
      }
    } on DioException catch (dioError) {
      // معالجة أخطاء Dio بشكل أكثر تفصيلاً
      String errorMessage = _handleDioError(dioError);
      emit(ErrorCourses(errorMessage));
    } catch (error) {
      emit(ErrorCourses('Unexpected error: ${error.toString()}'));
    }
  }

  // دالة لمعالجة أخطاء Dio
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode ?? 'Unknown'}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.unknown:
        return 'Unknown error occurred. Please try again.';
      default:
        return 'Network error: ${error.message}';
    }
  }

  // دالة لإعادة المحاولة
  void retryCourses() {
    getCourses();
  }

  // دالة لتصفية الكورسات حسب الفئة
  void getCoursesByCategory(String category) {
    if (_courses.isEmpty) {
      getCourses();
      return;
    }

    emit(LoadingCourses());

    final filteredCourses = _courses
        .where((course) =>
    course.category?.toLowerCase() == category.toLowerCase())
        .toList();

    emit(SuccessCourses(filteredCourses));
  }

  // دالة للبحث في الكورسات
  void searchCourses(String query) {
    if (_courses.isEmpty) {
      getCourses();
      return;
    }

    emit(LoadingCourses());

    final searchResults = _courses
        .where((course) =>
    course.title?.toLowerCase().contains(query.toLowerCase()) == true ||
        course.description?.toLowerCase().contains(query.toLowerCase()) == true)
        .toList();

    emit(SuccessCourses(searchResults));
  }

  // دالة لإرجاع جميع الكورسات
  void getAllCourses() {
    if (_courses.isEmpty) {
      getCourses();
    } else {
      emit(SuccessCourses(_courses));
    }
  }

  // دالة لتحديث الكورسات
  void refreshCourses() {
    _courses.clear();
    getCourses();
  }
}