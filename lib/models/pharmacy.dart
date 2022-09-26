class Pharmacy {
  String? id;
  String? name;
  String? phone;

  Pharmacy({id, this.name, this.phone});

  Pharmacy.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    name = map['name'];
    phone = map['phone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'adminRole': 'pharmacy',
    };
  }

  @override
  bool operator ==(other) =>
      other is Pharmacy &&
      other.id == id &&
      other.name == name &&
      phone == other.phone;

  @override
  int get hashCode => Object.hash(id, name, phone);
}
