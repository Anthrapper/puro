import 'package:puro/src/version.dart';
import 'package:test/test.dart';

void main() {
  test('Windows ARM64 build target parses', () {
    final target = PuroBuildTarget.fromString('windows-arm64');

    expect(target, PuroBuildTarget.windowsArm64);
    expect(target.name, 'windows-arm64');
    expect(target.executableName, 'puro.exe');
    expect(target.trampolineName, 'puro.bat');
    expect(target.dartName, 'dart.bat');
    expect(target.flutterName, 'flutter.bat');
  });

  test('Existing build targets still parse', () {
    expect(
      PuroBuildTarget.fromString('windows-x64'),
      PuroBuildTarget.windowsX64,
    );
    expect(PuroBuildTarget.fromString('linux-x64'), PuroBuildTarget.linuxX64);
    expect(PuroBuildTarget.fromString('darwin-x64'), PuroBuildTarget.macosX64);
    expect(
      PuroBuildTarget.fromString('darwin-arm64'),
      PuroBuildTarget.macosArm64,
    );
  });

  test('Unknown build target throws', () {
    expect(
      () => PuroBuildTarget.fromString('windows-arm'),
      throwsArgumentError,
    );
  });
}
