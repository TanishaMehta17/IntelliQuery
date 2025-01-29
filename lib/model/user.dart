
  import 'dart:convert';

  class User {
    final String id;
    final String name;
    final String email;
    final String password;
   
    final String confirmpas;
    final String token;

    User({
      required this.id,
      required this.name,
      required this.email,
      required this.password,
      
      required this.confirmpas,
      required this.token,
    });

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
     
        'confirmpas': confirmpas,
        'token': token,
      };
    }

    factory User.fromMap(Map<String, dynamic> map) {
      return User(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
     
        confirmpas: map['confirmpas'] ?? '',
        token: map['token'] ?? '',
      );
    }

    String toJson() => json.encode(toMap());

    factory User.fromJson(String source) => User.fromMap(json.decode(source));

    User copyWith({
      String? id,
      String? name,
      String? email,
      String? password,
      String? confirmpas,
      String? token,
    }) {
      return User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
  
        confirmpas: confirmpas ?? this.confirmpas,
        token: token ?? this.token,
      );
    }
  }
 