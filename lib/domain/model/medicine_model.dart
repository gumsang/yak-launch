import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 1)
class MeidicineModel extends HiveObject {
  MeidicineModel({
    required this.id,
    required this.name,
    required this.alarms,
    required this.imagePath,
  });

  //id(식별할 아이디), name, image(optional), alarms
  @HiveField(0)
  final int id; //unique id,

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final List<String> alarms;

  @override
  String toString() {
    return 'id:$id, name: $name, alarms: $alarms, imagepath:$imagePath';
  }
}
