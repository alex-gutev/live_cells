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

    AutoKey.withAutoKeys((_) => 'test_key_${i++}', () {
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

    AutoKey.withAutoKeys((_) => 'test2_key_${i++}', () {
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

    AutoKey.withAutoKeys((_) => 'test3_key_${i += 5}', () {
      c1 = MutableCell(5);
      c2 = MutableCell(5, key: 'preset_key');
      c3 = MutableCell(5);
    });

    final k1 = MutableCell(5, key: 'test3_key_15');
    final k2 = MutableCell(5, key: 'preset_key');
    final k3 = MutableCell(5, key: 'test3_key_20');

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

    AutoKey.withAutoKeys((_) => 'test4_key_${i++}', () {
      c1 = (a,b).mutableApply((a,b) => a + b, (_) { });
      c2 = MutableComputeCell(
          arguments: {a,b},
          compute: () => a.value + b.value,
          reverseCompute: (_) {},
          key: 'preset_key'
      );
      c3 = (a,b).mutableApply((a,b) => a + b, (_) { });
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

    AutoKey.withAutoKeys((_) => 'test5_key_${i++}', () {
      c1 = MutableCell.computed(() => a() + b(), (_) { });
      c2 = MutableCell.computed(() => a() + b(), (_) { }, key: 'preset_key');
      c3 = MutableCell.computed(() => a() + b(), (_) { });
    });

    final k1 = MutableCell.computed(() => a() + b(), (_) { }, key: 'test5_key_0');
    final k2 = MutableCell.computed(() => a() + b(), (_) { }, key: 'preset_key');
    final k3 = MutableCell.computed(() => a() + b(), (_) { }, key: 'test5_key_1');

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

    AutoKey.withAutoKeys((_) => 'test6_key_${i++}', () {
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

    AutoKey.withAutoKeys((_) => 'level1_key_${i++}', () {
      AutoKey.withAutoKeys((_) => 'level2_key_${i++}', () {
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

  test('Keys generated automatically for ValueCell.watch', () {
    late final CellWatcher w1;
    late final CellWatcher w2;
    late final CellWatcher w3;

    var i = 0;

    AutoKey.withAutoWatchKeys((p0) => 'test_key_${i++}', () {
      w1 = ValueCell.watch(() { });
      w2 = ValueCell.watch(() { });
      w3 = ValueCell.watch(() { }, key: 'preset_key');
    });

    final k1 = ValueCell.watch(() { }, key: 'test_key_0');
    final k2 = ValueCell.watch(() { }, key: 'test_key_1');
    final k3 = ValueCell.watch(() { }, key: 'preset_key');


    expect(w1 == k1, isTrue);
    expect(w2 == k2, isTrue);
    expect(w3 == k3, isTrue);

    expect(w1 != k3, isTrue);
    expect(w3 != k1, isTrue);
  });

  test('Keys generated automatically for Watch', () {
    late final Watch w1;
    late final Watch w2;
    late final Watch w3;

    var i = 0;

    AutoKey.withAutoWatchKeys((p0) => 'test_key_${i++}', () {
      w1 = Watch((_) { });
      w2 = Watch((_) { });
      w3 = Watch((_) { }, key: 'preset_key');
    });

    final k1 = Watch((_) { }, key: 'test_key_0');
    final k2 = Watch((_) { }, key: 'test_key_1');
    final k3 = Watch((_) { }, key: 'preset_key');


    expect(w1 == k1, isTrue);
    expect(w2 == k2, isTrue);
    expect(w3 == k3, isTrue);

    expect(w1 != k3, isTrue);
    expect(w3 != k1, isTrue);
  });

  test('Previous watch key generation function restored automatically', () {
    late final CellWatcher w1;
    late final CellWatcher w2;

    var i = 0;

    AutoKey.withAutoWatchKeys((_) => 'level1_key_${i++}', () {
      AutoKey.withAutoWatchKeys((_) => 'level2_key_${i++}', () {
        w1 = ValueCell.watch(() { });
      });

      w2 = ValueCell.watch(() { });
    });

    final w3 = ValueCell.watch(() { });

    final k1 = ValueCell.watch(() { }, key: 'level2_key_0');
    final k2 = ValueCell.watch(() { }, key: 'level1_key_1');

    expect(w1 == k1, isTrue);
    expect(w2 == k2, isTrue);

    expect(w3.key, isNull);

    expect(w1 != k2, isTrue);
    expect(w2 != k1, isTrue);
  });
}