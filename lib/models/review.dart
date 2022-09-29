import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? id;
  double? rating;
  String? userId;
  String? comment;
  DateTime? dateTime;
  String? orderId;

  Review(
      {this.id,
      this.rating,
      this.userId,
      this.comment,
      this.dateTime,
      this.orderId});

  Review.fromFirestore(Map<String, dynamic> map, String rId) {
    id = rId;
    rating = map['rating'];
    userId = map['userId'];
    comment = map['comment'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
    orderId = map['orderId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'userId': userId,
      'comment': comment,
      'dateTime': dateTime,
      'orderId': orderId,
    };
  }
}
