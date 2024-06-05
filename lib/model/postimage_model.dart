class ImagePostModel {
  String? image;
  String? description;
  String? uid;
  dynamic username;
  String? userImage;

  ImagePostModel({this.image, this.description, this.uid,this.username,this.userImage});

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
    uid = json["uid"];
    username=json["username"];
    userImage=json["userimage"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
      "uid": uid,
      "username":username,
      "userimage":userImage
    };
  }
}