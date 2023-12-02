import 'package:flutter_test/flutter_test.dart';

import 'package:live_cells/live_cells.dart';
import 'package:mockito/mockito.dart';

class Listener {
  void onChange() {}
}

class MockListener extends Mock implements Listener {}

void main() {
  group('ConstantCell', () {
    test('Integer ConstantCell.value equals value given in constructor', () {
      final cell = ConstantCell(10);
      expect(cell.value, equals(10));
    });
    test('String ConstantCell.value equals value given in constructor', () {
      final cell = ConstantCell('Hello World');
      expect(cell.value, equals('Hello World'));
    });
  });

  group('MutableCell', () {
    test('MutableCell.value equals initial value when not changed', () {
      final cell = MutableCell(15);
      expect(cell.value, equals(15));
    });

    test('Setting MutableCell.value changes cell value', () {
      final cell = MutableCell(15);
      cell.value = 23;

      expect(cell.value, equals(23));
    });

    test('MutableCell.value keeps latest value that was set', () {
      final cell = MutableCell(15);
      cell.value = 23;
      cell.value = 101;

      expect(cell.value, equals(101));
    });

    test('Setting MutableCell.value calls cell listeners', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 23;

      verify(listener.onChange()).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);

      cell.value = 23;
      cell.value = 101;

      verify(listener.onChange()).called(2);
    });

    test('MutableCell listener not called after it is removed', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 23;

      cell.removeListener(listener.onChange);
      cell.value = 101;

      verify(listener.onChange()).called(1);
    });

    test('MutableCell listener not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 56;

      verifyNever(listener.onChange());
    });
  });
}
