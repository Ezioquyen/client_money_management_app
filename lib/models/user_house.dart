class UserHouse{
  int userId;
  String houseId;
  bool role;
  UserHouse(this.userId, this.houseId, this.role);
  Map<String, dynamic> toJson() {
    return {
      'id': {
        'houseId': houseId,
        'userId': userId,
      },
      'userRole': role,
    };
  }
}