class UserModel{
  String? uid;
  String? email;
  String? name;
  String? lastName;
  String? status;

  UserModel({this.uid, this.email, this.name, this.lastName, this.status});

  //Receive data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      lastName: map['lastName'],
      status: map['status'],
    );
  }

  //Send data to the server
  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'name': name,
      'lastName': lastName,
      'status': status,
    };
  }
}