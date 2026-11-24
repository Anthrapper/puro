import 'package:puro/src/env/engine.dart';
import 'package:test/test.dart';

const _windowsArm64Output =
    'Dart SDK version: 3.14.0 (stable) on "windows_arm64"';
const _windowsX64Output = 'Dart SDK version: 3.14.0 (stable) on "windows_x64"';

void main() {
  test('Windows ARM64 engine target maps to the ARM64 Dart SDK', () {
    final target = EngineBuildTarget.from(EngineOS.windows, EngineArch.arm64);

    expect(target, EngineBuildTarget.windowsArm64);
    expect(target.zipName, 'dart-sdk-windows-arm64.zip');
    expect(target.os, EngineOS.windows);
    expect(target.arch, EngineArch.arm64);
  });

  test('Existing engine targets still map', () {
    expect(
      EngineBuildTarget.from(EngineOS.windows, EngineArch.x64),
      EngineBuildTarget.windowsX64,
    );
    expect(
      EngineBuildTarget.from(EngineOS.macOS, EngineArch.arm64),
      EngineBuildTarget.macosArm64,
    );
    expect(
      EngineBuildTarget.from(EngineOS.linux, EngineArch.arm64),
      EngineBuildTarget.linuxArm64,
    );
  });

  test('ARM64 engine targets fall back to x64', () {
    expect(
      EngineBuildTarget.windowsArm64.fallback,
      EngineBuildTarget.windowsX64,
    );
    expect(EngineBuildTarget.macosArm64.fallback, EngineBuildTarget.macosX64);
    expect(EngineBuildTarget.windowsX64.fallback, isNull);
    expect(EngineBuildTarget.linuxArm64.fallback, isNull);
  });

  test('Cached Dart SDK architecture must match the requested target', () {
    expect(
      dartSdkMatchesEngineBuildTarget(
        _windowsArm64Output,
        EngineBuildTarget.windowsArm64,
      ),
      isTrue,
    );
    expect(
      dartSdkMatchesEngineBuildTarget(
        _windowsX64Output,
        EngineBuildTarget.windowsArm64,
      ),
      isFalse,
    );
    expect(
      dartSdkMatchesEngineBuildTarget(
        _windowsArm64Output,
        EngineBuildTarget.windowsX64,
      ),
      isFalse,
    );
  });

  test('Cached Dart SDK fallback requires an explicit fallback marker', () {
    expect(
      dartSdkMatchesEngineBuildTarget(
        _windowsX64Output,
        EngineBuildTarget.windowsArm64,
      ),
      isFalse,
    );
    expect(
      dartSdkMatchesEngineBuildTarget(
        _windowsX64Output,
        EngineBuildTarget.windowsArm64,
        allowFallback: true,
      ),
      isTrue,
    );
    expect(
      dartSdkMatchesEngineBuildTarget(
        'unrecognized output',
        EngineBuildTarget.windowsArm64,
        allowFallback: true,
      ),
      isFalse,
    );
  });
}
