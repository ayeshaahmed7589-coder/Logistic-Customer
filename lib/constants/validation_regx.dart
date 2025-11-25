class AppValidators {
  // ---------------- EMAIL ----------------
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$",
    );

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid Email ID";
    }
    return null;
  }

  // ---------------- PASSWORD ----------------
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  // ---------------- NEW PASSWORD (STRONG) ----------------
  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "New password is required";
    }

    if (value.length < 8) {
      return "Minimum 8 characters required";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain at least one uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Must contain at least one lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain at least one number";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must contain at least one special character";
    }

    return null;
  }

  // ---------------- CONFIRM PASSWORD ----------------
  static String? confirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }

    if (value != newPassword) {
      return "Passwords do not match";
    }

    return null;
  }

  // ---------------- OTP ----------------
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP is required";
    }

    if (value.length != 6) {
      return "Enter 6-digit OTP";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "OTP must be numeric";
    }

    return null;
  }

  // ---------------- FIRST NAME / LAST NAME ----------------
  static String? name(String? value, {String fieldName = "Name"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
      return "$fieldName must contain only letters";
    }

    if (value.length < 2) {
      return "$fieldName is too short";
    }

    return null;
  }

  // ---------------- PHONE NUMBER ----------------
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile number is required";
    }

    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return "Enter valid mobile number";
    }

    return null;
  }

  // ---------------- DATE OF BIRTH ----------------
  static String? dob(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Date of Birth is required";
    }

    // Check format YYYY-MM-DD
    final dobRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dobRegex.hasMatch(value)) {
      return "Enter DOB in YYYY-MM-DD format";
    }

    return null;
  }

  // ---------------- REQUIRED GENERIC ----------------
  static String? required(String? value, {String field = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }
    return null;
  }
}
