class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String houseNo;
  final String area;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String addressType;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.houseNo,
    required this.area,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.addressType,
    required this.isDefault,
  });

  factory AddressModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return AddressModel(
      id: id,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      houseNo: map['houseNo'] ?? '',
      area: map['area'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      addressType: map['addressType'] ?? 'Home',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'houseNo': houseNo,
      'area': area,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }
}