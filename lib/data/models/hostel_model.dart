import 'dart:convert';
import 'package:flutter/foundation.dart';

class HostelModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int totalRooms;
  final int availableRooms;
  final double rent;
  final String contact;
  final List<String> facilities;
  final bool isActive;
  final String? url;
  final List<String> imageUrls;
  final String? ownerName;

  HostelModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalRooms,
    required this.availableRooms,
    required this.rent,
    required this.contact,
    required this.facilities,
    required this.isActive,
    this.imageUrls = const [],
    this.ownerName,
    this.url,
  });

  List<String> get allImages {
    final List<String> images = [...imageUrls];
    if (url != null && url!.isNotEmpty && !images.contains(url)) {
      images.insert(0, url!);
    }
    return images;
  }

  String? get coverImage => allImages.isNotEmpty ? allImages.first : null;

  int get occupiedRooms => totalRooms - availableRooms;
  bool get isFull => availableRooms <= 0;
  double get occupancyRate =>
      totalRooms == 0 ? 0 : (occupiedRooms / totalRooms);

  HostelModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? totalRooms,
    int? availableRooms,
    double? rent,
    String? contact,
    List<String>? facilities,
    bool? isActive,
    String? url,
    List<String>? imageUrls,
    String? ownerName,
  }) {
    return HostelModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalRooms: totalRooms ?? this.totalRooms,
      availableRooms: availableRooms ?? this.availableRooms,
      rent: rent ?? this.rent,
      contact: contact ?? this.contact,
      facilities: facilities ?? this.facilities,
      isActive: isActive ?? this.isActive,
      url: url ?? this.url,
      imageUrls: imageUrls ?? this.imageUrls,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'rent': rent,
      'contact': contact,
      'facilities': facilities,
      'isActive': isActive,
      'ownerName': ownerName,
      'url': url,
      'imageUrls': imageUrls,
    };
  }

  factory HostelModel.fromMap(Map<String, dynamic> map) {
    final total = map['totalRooms'] ?? 0;
    return HostelModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      totalRooms: total,
      availableRooms: map['availableRooms'] ?? total,
      rent: (map['rent'] ?? 0.0).toDouble(),
      contact: map['contact'] ?? '',
      facilities: List<String>.from(map['facilities'] ?? []),
      isActive: map['isActive'] ?? true,
      url: map['url'],

      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      ownerName: map['ownerName'],
    );
  }

  String toJson() => json.encode(toMap());
  factory HostelModel.fromJson(String source) =>
      HostelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HostelModel(id: $id, name: $name, images: ${allImages.length})';
  }

  @override
  bool operator ==(covariant HostelModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.totalRooms == totalRooms &&
        other.availableRooms == availableRooms &&
        other.rent == rent &&
        other.contact == contact &&
        listEquals(other.facilities, facilities) &&
        other.isActive == isActive &&
        other.url == url &&
        listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        totalRooms.hashCode ^
        availableRooms.hashCode ^
        rent.hashCode ^
        contact.hashCode ^
        facilities.hashCode ^
        isActive.hashCode ^
        url.hashCode ^
        imageUrls.hashCode;
  }
}
