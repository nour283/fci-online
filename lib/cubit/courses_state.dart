import 'package:tadrib_hub/models/Courses_Model.dart';

abstract class CoursesState {}

class InitialState extends CoursesState{}

class LoadingCourses extends CoursesState{}

class SuccessCourses extends CoursesState{
  List<Courses> allCourses = [];
  SuccessCourses(this.allCourses);
}

class ErrorCourses extends CoursesState{
  String error;
  ErrorCourses(this.error);
}
