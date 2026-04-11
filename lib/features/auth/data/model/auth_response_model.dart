class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String id;
  final User user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.id,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      role: json["role"] ?? "",
      id: json["_id"] ?? "",
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "role": role,
      "_id": id,
      "user": user.toJson(),
    };
  }
}

class PhotoModel {
  final String publicId;
  final String url;

  PhotoModel({required this.publicId, required this.url});

  factory PhotoModel.fromJson(dynamic json) {
    // Backend may return either:
    // 1) an object: { public_id, url }
    // 2) a plain string path: "uploads/...jpg"
    if (json is String) {
      return PhotoModel(publicId: '', url: json);
    }

    if (json is! Map<String, dynamic>) {
      return PhotoModel(publicId: '', url: '');
    }

    return PhotoModel(
      publicId: json["public_id"] ?? "",
      url: json["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"public_id": publicId, "url": url};
  }
}

class IdentityVerificationModel {
  final String documentType;
  final String documentNumber;
  final String status;
  final PhotoModel idFile;
  final PhotoModel passportDrivingLicense;
  final PhotoModel insurance;

  IdentityVerificationModel({
    required this.documentType,
    required this.documentNumber,
    required this.status,
    required this.idFile,
    required this.passportDrivingLicense,
    required this.insurance,
  });

  factory IdentityVerificationModel.fromJson(Map<String, dynamic> json) {
    return IdentityVerificationModel(
      documentType: json["documentType"] ?? "",
      documentNumber: json["documentNumber"] ?? "",
      status: json["status"] ?? "pending",
      idFile: PhotoModel.fromJson(
        json["idFile"] ?? {"public_id": "", "url": ""},
      ),
      passportDrivingLicense: PhotoModel.fromJson(
        json["passportDrivingLicense"] ?? {"public_id": "", "url": ""},
      ),
      insurance: PhotoModel.fromJson(
        json["insurance"] ?? {"public_id": "", "url": ""},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentType": documentType,
      "documentNumber": documentNumber,
      "status": status,
      "idFile": idFile.toJson(),
      "passportDrivingLicense": passportDrivingLicense.toJson(),
      "insurance": insurance.toJson(),
    };
  }
}

class DrivewayEligibilityModel {
  final bool isPrivateProperty;
  final bool hasPermission;
  final bool noRoadPayment;
  final bool oneCarSpaceOnly;
  final bool notSharedOrCommunal;

  DrivewayEligibilityModel({
    required this.isPrivateProperty,
    required this.hasPermission,
    required this.noRoadPayment,
    required this.oneCarSpaceOnly,
    required this.notSharedOrCommunal,
  });

  factory DrivewayEligibilityModel.fromJson(Map<String, dynamic> json) {
    return DrivewayEligibilityModel(
      isPrivateProperty: json["isPrivateProperty"] ?? false,
      hasPermission: json["hasPermission"] ?? false,
      noRoadPayment: json["noRoadPayment"] ?? false,
      oneCarSpaceOnly: json["oneCarSpaceOnly"] ?? false,
      notSharedOrCommunal: json["notSharedOrCommunal"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isPrivateProperty": isPrivateProperty,
      "hasPermission": hasPermission,
      "noRoadPayment": noRoadPayment,
      "oneCarSpaceOnly": oneCarSpaceOnly,
      "notSharedOrCommunal": notSharedOrCommunal,
    };
  }
}

class User {
  final VerificationInfo verificationInfo;
  final PhotoModel photo;
  final IdentityVerificationModel identityVerification;
  final DrivewayEligibilityModel drivewayEligibility;
  final BankDetails bankDetails;
  final InsuranceModel insurance;
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final bool isOnline;
  final bool isBusy;
  final int dailyWashLimit;
  final String passwordResetToken;
  final String refreshToken;
  final bool isEmailVerified;
  final String language;
  final String serviceArea;
  final String nationalInsuranceNumber;
  final String residentialAddress;
  final bool rightToWorkUK;
  final bool isProfileCompleted;
  final bool isIdentityCompleted;
  final bool isBankCompleted;
  final List<String> preferredServices;
  final String createdAt;
  final String updatedAt;
  final int v;

  User({
    required this.verificationInfo,
    required this.photo,
    required this.identityVerification,
    required this.drivewayEligibility,
    required this.bankDetails,
    required this.insurance,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.isOnline,
    required this.isBusy,
    required this.dailyWashLimit,
    required this.passwordResetToken,
    required this.refreshToken,
    required this.isEmailVerified,
    required this.language,
    required this.serviceArea,
    required this.nationalInsuranceNumber,
    required this.residentialAddress,
    required this.rightToWorkUK,
    required this.isProfileCompleted,
    required this.isIdentityCompleted,
    required this.isBankCompleted,
    required this.preferredServices,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      verificationInfo: VerificationInfo.fromJson(json["verificationInfo"] ?? {}),
      photo: PhotoModel.fromJson(json["photo"] ?? {}),
      identityVerification: IdentityVerificationModel.fromJson(json["identityVerification"] ?? {}),
      drivewayEligibility: DrivewayEligibilityModel.fromJson(json["drivewayEligibility"] ?? {}),
      bankDetails: BankDetails.fromJson(json["bankDetails"] ?? {}),
      insurance: InsuranceModel.fromJson(json["insurance"] ?? {}),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "user",
      isOnline: json["isOnline"] ?? false,
      isBusy: json["isBusy"] ?? false,
      dailyWashLimit: json["dailyWashLimit"] ?? 7,
      passwordResetToken: json["password_reset_token"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      isEmailVerified: json["isEmailVerified"] ?? false,
      language: json["language"] ?? "English",
      serviceArea: json["serviceArea"] ?? "",
      nationalInsuranceNumber: json["nationalInsuranceNumber"] ?? "",
      residentialAddress: json["residentialAddress"] ?? "",
      rightToWorkUK: json["rightToWorkUK"] ?? false,
      isProfileCompleted: json["isProfileCompleted"] ?? false,
      isIdentityCompleted: json["isIdentityCompleted"] ?? false,
      isBankCompleted: json["isBankCompleted"] ?? false,
      preferredServices: List<String>.from(json["preferredServices"] ?? []),
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "verificationInfo": verificationInfo.toJson(),
      "photo": photo.toJson(),
      "identityVerification": identityVerification.toJson(),
      "drivewayEligibility": drivewayEligibility.toJson(),
      "bankDetails": bankDetails.toJson(),
      "insurance": insurance.toJson(),
      "_id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "isOnline": isOnline,
      "isBusy": isBusy,
      "dailyWashLimit": dailyWashLimit,
      "password_reset_token": passwordResetToken,
      "refreshToken": refreshToken,
      "isEmailVerified": isEmailVerified,
      "language": language,
      "serviceArea": serviceArea,
      "nationalInsuranceNumber": nationalInsuranceNumber,
      "residentialAddress": residentialAddress,
      "rightToWorkUK": rightToWorkUK,
      "isProfileCompleted": isProfileCompleted,
      "isIdentityCompleted": isIdentityCompleted,
      "isBankCompleted": isBankCompleted,
      "preferredServices": preferredServices,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({required this.publicId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(publicId: json["public_id"] ?? "", url: json["url"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"public_id": publicId, "url": url};
  }
}

class InsuranceModel {
  final PhotoModel document;

  InsuranceModel({required this.document});

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      document: PhotoModel.fromJson(json["document"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {"document": document.toJson()};
  }
}

class VerificationInfo {
  final bool verified;
  final String token;

  VerificationInfo({required this.verified, required this.token});

  factory VerificationInfo.fromJson(Map<String, dynamic> json) {
    return VerificationInfo(
      verified: json["verified"] ?? false,
      token: json["token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"verified": verified, "token": token};
  }
}

class BankDetails {
  final String accountHolderName;
  final String accountNumber;
  final String address;
  final String city;
  final String postcode;
  final String sortCode;

  BankDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.address,
    required this.city,
    required this.postcode,
    required this.sortCode,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountHolderName: json["accountHolderName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      postcode: json["postcode"] ?? "",
      sortCode: json["sortCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accountHolderName": accountHolderName,
      "accountNumber": accountNumber,
      "address": address,
      "city": city,
      "postcode": postcode,
      "sortCode": sortCode,
    };
  }
  
  // Helper to check if bank details are empty
  bool get isEmpty {
    return accountHolderName.isEmpty &&
           accountNumber.isEmpty &&
           sortCode.isEmpty;
  }
}
