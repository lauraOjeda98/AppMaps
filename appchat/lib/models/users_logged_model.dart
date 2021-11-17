class UsersLoggedModel{
  String? uid;
  String? loggedIn;
  String? name;
  String? lastname;

  UsersLoggedModel({this.uid, this.loggedIn, this.name, this.lastname});

  //Receive data from server
  factory UsersLoggedModel.fromMap(map){
    return UsersLoggedModel(
      uid: map['uid'],
      loggedIn: map['loggedIn'],
      name: map['name'],
      lastname: map['lastname'],
    );
  }

  //Send data to the server
  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'loggedIn': loggedIn,
      'name': name,
      'lastname': lastname,
    };
  }
}