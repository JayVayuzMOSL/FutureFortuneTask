import 'package:flutter/src/widgets/framework.dart';

class AppStrings {
  static const String appName = 'Future Fortune';
  static const String signUp = 'Sign Up';
  static const String dontHaveAccount = "Don't have account?Sign Up";
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String fullName = 'Full Name';
  static const String addItem = 'Add Task';
  static const String notes = 'Notes';
  static const String home = 'Home';
  static const String logout = 'Logout';
  static const String taskAddedSuccess = 'Task Added Successfully!';
  static const String deleteTask = 'Delete Task';
  static const String editTask = 'Edit Task';
  static const String confirmDelete = 'Are you sure?\nYou are about to delete this task. This action cannot be undone.';

  static const String title = "Title";
  static const String save='Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  static const String userIdKey = "user_id";
  static const String loginFailed = "Login failed, please try again";

  // Validation messages
  static const String emailRequired = "Email is required";
  static const String invalidEmail = "Enter a valid email";
  static const String passwordRequired = "Password is required";
  static const String passwordTooShort = "Password must be at least 6 characters";

  // Regex
  static const String emailRegex = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

  static const String alreadyHaveAccount='Already have an account?Login';

  static const String fullNameRequired='Full Name is required';

  static const String noNotesAvailable='No notes available';

  static const String taskUpdatedSuccess='Task has been updated successfully.';

  static const String newTask='New Task';

  static const String titleEmptyError='Title is not empty';

  static const String notesEmptyError='Notes are not empty';

  static const String category='Category';

  static const String priority='Priority';

  static const String searchNotes="Search notes";
}
