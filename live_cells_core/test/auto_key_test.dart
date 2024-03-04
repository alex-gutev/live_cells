import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Keys generated automatically for stateless computed cells', () {
    final a = MutableCell(0);
    final b = MutableCell(1);

    late final ValueCell<int> c1;
    late final ValueCell<int> c2;
    late final ValueCell<int> c3;

    var i = 0;

    AutoKey.withAutoKeys(() => 'test_key_${i++}', () {
      c1 = (a, b).apply((a, b) => a + b);
      c2 = (a, b).apply((a, b) => a + b, key: 'preset_key');
      c3 = (a, b).apply((a, b) => a + b);
    });

    final k1 = (a, b).apply((a, b) => a + b, key: 'test_key_0');
    final k2 = (a, b).apply((a, b) => a + b, key: 'preset_key');
    final k3 = (a, b).apply((a, b) => a + b, key: 'test_key_1');

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Keys generated automatically for stateful computed cells', () {
    final a = MutableCell(0);
    final b = MutableCell(1);

    late final ValueCell<int> c1;
    late final ValueCell<int> c2;
    late final ValueCell<int> c3;

    var i = 0;

    AutoKey.withAutoKeys(() => 'test2_key_${i++}', () {
      c1 = ValueCell.computed(() => a() + b());
      c2 = ValueCell.computed(() => a() + b(), key: 'preset_key');
      c3 = ValueCell.computed(() => a() + b());
    });

    final k1 = ValueCell.computed(() => a() + b(), key: 'test2_key_0');
    final k2 = ValueCell.computed(() => a() + b(), key: 'preset_key');
    final k3 = ValueCell.computed(() => a() + b(), key: 'test2_key_1');

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Keys generated automatically for mutable cells', () {
    late final MutableCell<int> c1;
    late final MutableCell<int> c2;
    late final MutableCell<int> c3;

    var i = 10;

    AutoKey.withAutoKeys(() => 'test3_key_${i += 5}', () {
      c1 = MutableCell(5);
      c2 = MutableCell(5, key: 'preset_key');
      c3 = MutableCell(5);
    });

    addTearDown(() {
      c1.dispose();
      c2.dispose();
      c3.dispose();
    });

    final k1 = MutableCell(5, key: 'test3_key_15');
    final k2 = MutableCell(5, key: 'preset_key');
    final k3 = MutableCell(5, key: 'test3_key_20');

    addTearDown(() {
      k1.dispose();
      k2.dispose();
      k3.dispose();
    });

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Keys generated automatically for mutable computed cells', () {
    final a = MutableCell(0);
    final b = MutableCell(1);

    late final MutableCell<int> c1;
    late final MutableCell<int> c2;
    late final MutableCell<int> c3;

    var i = 5;

    AutoKey.withAutoKeys(() => 'test4_key_${i++}', () {
      c1 = (a,b).mutableApply((a,b) => a + b, (_) { });
      c2 = MutableComputeCell(
          arguments: {a,b},
          compute: () => a.value + b.value,
          reverseCompute: (_) {},
          key: 'preset_key'
      );
      c3 = (a,b).mutableApply((a,b) => a + b, (_) { });
    });

    addTearDown(() {
      c1.dispose();
      c2.dispose();
      c3.dispose();
    });

    final k1 = MutableComputeCell(
      arguments: {a,b},
      compute: () => a.value + b.value,
      reverseCompute: (_) {},
      key: 'test4_key_5'
    );

    final k2 = MutableComputeCell(
        arguments: {a,b},
        compute: () => a.value + b.value,
        reverseCompute: (_) {},
        key: 'preset_key'
    );

    final k3 = MutableComputeCell(
        arguments: {a,b},
        compute: () => a.value + b.value,
        reverseCompute: (_) {},
        key: 'test4_key_6'
    );

    addTearDown(() {
      k1.dispose();
      k2.dispose();
      k3.dispose();
    });

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Keys generated automatically for dynamic mutable computed cells', () {
    final a = MutableCell(0);
    final b = MutableCell(1);

    late final MutableCell<int> c1;
    late final MutableCell<int> c2;
    late final MutableCell<int> c3;

    var i = 0;

    AutoKey.withAutoKeys(() => 'test5_key_${i++}', () {
      c1 = MutableCell.computed(() => a() + b(), (_) { });
      c2 = MutableCell.computed(() => a() + b(), (_) { }, key: 'preset_key');
      c3 = MutableCell.computed(() => a() + b(), (_) { });
    });

    addTearDown(() {
      c1.dispose();
      c2.dispose();
      c3.dispose();
    });

    final k1 = MutableCell.computed(() => a() + b(), (_) { }, key: 'test5_key_0');
    final k2 = MutableCell.computed(() => a() + b(), (_) { }, key: 'preset_key');
    final k3 = MutableCell.computed(() => a() + b(), (_) { }, key: 'test5_key_1');

    addTearDown(() {
      k1.dispose();
      k2.dispose();
      k3.dispose();
    });

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Keys generated automatically for mutable cell views', () {
    final a = MutableCell(0);

    late final MutableCell<int> c1;
    late final MutableCell<int> c2;
    late final MutableCell<int> c3;

    var i = 0;

    AutoKey.withAutoKeys(() => 'test6_key_${i++}', () {
      c1 = a.mutableApply((p0) => p0 + 1, (p0) { });
      c2 = a.mutableApply((p0) => p0 + 1, (p0) { }, key: 'preset_key');
      c3 = a.mutableApply((p0) => p0 + 1, (p0) { });
    });

    final k1 = a.mutableApply((p0) => p0 + 1, (p0) { }, key: 'test6_key_0');
    final k2 = a.mutableApply((p0) => p0 + 1, (p0) { }, key: 'preset_key');
    final k3 = a.mutableApply((p0) => p0 + 1, (p0) { }, key: 'test6_key_1');

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);
    expect(c3 == k3, isTrue);

    expect(c1 != k3, isTrue);
    expect(c3 != k1, isTrue);
  });

  test('Previous key generation function restored automatically', () {
    final a = MutableCell(0);

    late final ValueCell<int> c1;
    late final ValueCell<int> c2;

    var i = 0;

    AutoKey.withAutoKeys(() => 'level1_key_${i++}', () {
      AutoKey.withAutoKeys(() => 'level2_key_${i++}', () {
        c1 = a.apply((value) => value + 1);
      });

      c2 = a.apply((value) => value + 1);
    });

    final c3 = a.apply((value) => value + 1);

    final k1 = a.apply((value) => value + 1, key: 'level2_key_0');
    final k2 = a.apply((value) => value + 1, key: 'level1_key_1');

    expect(c1 == k1, isTrue);
    expect(c2 == k2, isTrue);

    expect((c3 as ComputeCell).key, isNull);

    expect(c1 != k2, isTrue);
    expect(c2 != k1, isTrue);
  });
}