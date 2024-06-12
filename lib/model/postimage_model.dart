class ImagePostModel {
  String? image;
  String? description;
  String? uid;
   bool? isLiked;
  dynamic username;
  String? userImage;

  ImagePostModel({this.image, this.description, this.uid,this.username,this.userImage,this.isLiked});

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
    uid = json["uid"];
    isLiked = json["is_liked"];
    username=json["username"];
    userImage=json["userimage"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
      "uid": uid,
      "is_liked": isLiked,
      "username":username,
      "userimage":userImage
    };
  }
}