import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dynamic_shape exports all essential classes, presets, and configs', () {
    expect(DynamicShapeType.values.length, 29);
    expect(BorderStyleType.values.length, 20);
    expect(SchoolShapePresets.attendanceConfig().type, DynamicShapeType.folderTab);
    const config = DynamicShapeConfig();
    expect(config.type, DynamicShapeType.smoothRounded);
  });
}
