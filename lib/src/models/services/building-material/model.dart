import 'pricing_model.dart';
import 'package:hive/hive.dart';
import '../../image_model.dart';

@HiveType(typeId: 10)
class BuildingMaterial extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String parent;
  @HiveField(3) ImageModel image;
  @HiveField(4) String description;
  @HiveField(5) List<BuildingMaterialPricing> pricing;

  BuildingMaterial({
    this.id,
    this.name,
    this.image,
    this.parent,
    this.pricing,
    this.description,
  });

  BuildingMaterial.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    parent = json['parent'];

    if (json['pricing'] != null) {
      pricing = List<BuildingMaterialPricing>();

      json['pricing'].forEach((v) {
        pricing.add(BuildingMaterialPricing.fromJson(v));
      });
    }

    description = json['description'];
    image = ImageModel.fromJson(json['image']);
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'image': this.image.serialize(),
    'parent': this.parent,

    'pricing': pricing
      ?.map((e) => e.toJson())
      ?.toList(),

    'description': this.description,
  };
}


