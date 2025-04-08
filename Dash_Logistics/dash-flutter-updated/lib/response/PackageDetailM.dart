class PackageDetailM {
  final String trackingCode;
  final String currentStatus;
  final String senderLocation;
   String senderName;
   String email;
   String senderContact;
   String receiverName;
   String receiverContact;
   String receiverGoogleAddress;
  final String receiverLocation;
   String productName;
   String receiverAlternaeNumber;
   String receiverNearestLandmark;
   String senderGoogleAddress;
  final int receiverLocationId;
  final int senderLocationId;
  final String totalPrice;
  final int hubId;
   String finalPackageWeight;
   String productPrice;
   String collectionPrice;
   String extraCharge;
   String senderLatitude;
   String senderLongitude;
   String receiverLatitude;
   String receiverLongitude;
   String paymentType;
   String extraChargeRemarks;
   String client;

  PackageDetailM({this.trackingCode, this.currentStatus, this.senderLocation,
    this.senderName,this.email,this.senderContact,this.receiverName,this.receiverContact,
    this.receiverGoogleAddress,this.receiverLocation,this.productName,this.receiverAlternaeNumber,this.receiverNearestLandmark,
    this.senderGoogleAddress, this.receiverLocationId,  this.senderLocationId,
    this.totalPrice,this.hubId,this.finalPackageWeight,this.productPrice,this.collectionPrice,this.extraCharge,
    this.senderLatitude,
    this.senderLongitude,  this.receiverLatitude, this.receiverLongitude,this.paymentType,this.extraChargeRemarks,this.client});

  factory PackageDetailM.fromJson(Map<String, dynamic> json) {
    return PackageDetailM(
      trackingCode: json['trackingCode'],
      currentStatus: json['currentStatus'],
      senderLocation: json['senderLocation'],
      senderName: json['senderName'],
      email: json['email'],
      senderContact: json['senderContact'],
      receiverName: json['receiverName'],
      receiverContact: json['receiverContact'],
      receiverGoogleAddress: json['receiverGoogleAddress'],
      receiverLocation: json['receiverLocation'],
      productName: json['productName'],
      receiverAlternaeNumber: json['receiverAlternaeNumber'],
      receiverNearestLandmark: json['receiverNearestLandmark'],
      senderGoogleAddress: json['senderGoogleAddress'],
      receiverLocationId: json['receiverLocationId'],
      senderLocationId: json['senderLocationId'],
      totalPrice: json['totalPrice'] == null ? null : json['totalPrice'].toString(),
      hubId: json['currentPackageHubId'],
      senderLatitude: json['senderLatitude'],
      senderLongitude: json['senderLongitude'],
      receiverLatitude: json['receiverLatitude'],
      receiverLongitude: json['receiverLongitude'],
      finalPackageWeight: json['finalPackageWeight'] == null ? null : json['finalPackageWeight'].toString(),
      collectionPrice: json['collectionPrice'] == null ? null : json['collectionPrice'].toString(),
      productPrice: json['productPrice'] == null ? null : json['productPrice'].toString(),
      paymentType: json['paymentType'],
      extraCharge: json['extraCharge'],
      extraChargeRemarks: json['extraChargeRemarks'],
      client: json['client'],
    );
  }
}