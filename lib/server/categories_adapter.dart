import 'package:flutter_application_1/models/expence.dart';
import 'package:hive/hive.dart';

class CategoriesAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    return Category.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeByte(obj.index);
  }
}
