import 'package:material_4/material_4.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('material_4 exports all essential classes, presets, and configs', () {
    expect(Material4Type.values.length, 41);
    expect(BorderStyleType.values.length, 32);
    expect(SchoolShapePresets.attendanceConfig().type, Material4Type.folderTab);
    const config = Material4Config();
    expect(config.type, Material4Type.smoothRounded);
  });
}
