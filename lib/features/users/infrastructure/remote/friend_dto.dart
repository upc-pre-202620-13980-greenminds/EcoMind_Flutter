class FriendDto {
  final int id;
  final int requesterId;
  final int receiverId;
  final String status;

  const new({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
  });

  factory FriendDto.fromJson(Map<String, dynamic> json) {
    return FriendDto(
      id: json['id'],
      requesterId: json['requesterId'],
      receiverId: json['receiverId'],
      status: json['status'],
    );
  }

  bool get isAccepted => status == 'ACCEPTED';

  // The friend is whoever of the two is not the parent
  int friendOf(int userId) => requesterId == userId ? receiverId : requesterId;
}
