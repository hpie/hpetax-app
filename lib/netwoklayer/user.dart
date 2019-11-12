class User extends Object {

  String user_id;
  String user_email;
  String user_password;

  String user_name;
  int user_type;
  String user_last_login;

  User({
    this.user_id = "",
    this.user_email = "",
    this.user_password = "",

    this.user_name = "",
    this.user_type = 1,
    this.user_last_login = "",
  });

  flush() {
    this.user_id = "";
    this.user_email = "";
    this.user_password = "";

    this.user_name = "";
    this.user_type = 1;
    this.user_last_login = "";
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        user_id: ((json['user_id']).toString()).toString() as String,
        user_email: (json['user_email']).toString() as String,
        user_password: (json['user_password']).toString() as String,

        user_name: json['user_name'] as String,
        user_type: json['user_type'] as int,
        user_last_login: json['user_last_login'] as String,
    );
  }

}