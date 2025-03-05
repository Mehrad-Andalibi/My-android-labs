class DataRepository {
  static String LoginName = "Guest";
  static int age = 18;

  static void setLoginName(String name) {
    LoginName = name;
  }

  static void setAge(int userAge) {
    age = userAge;
  }

  static String getLoginName() {
    return LoginName;
  }

  static int getAge() {
    return age;
  }
}