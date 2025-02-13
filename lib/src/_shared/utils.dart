typedef Predicate<T> = bool Function(T item);

typedef StateCallback<T> = void Function(T state);

abstract class Comparators {
  const Comparators._();

  static Comparator<T> sortSelectedFirst<T>({
    required bool Function(T) isSelected,
    Comparator<T>? comparator,
  }) {
    int selectedFirstComparator(T a, T b) {
      final aIsSelected = isSelected(a);
      final bIsSelected = isSelected(b);
      if (aIsSelected && bIsSelected) {
        return 0;
      } else if (aIsSelected && !bIsSelected) {
        return -1;
      } else if (!aIsSelected && bIsSelected) {
        return 1;
      } else {
        return 0;
      }
    }

    if (comparator != null) {
      return (a, b) {
        final isSelected = selectedFirstComparator(a, b);
        if (isSelected == 0) {
          return comparator(a, b);
        }
        return isSelected;
      };
    }
    return selectedFirstComparator;
  }
}

extension DateTimeExtension on DateTime {
  DateTime get onlyDate {
    return DateTime(year, month, day);
  }

  DateTime get onlyDateUtc {
    return DateTime.utc(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateTime get endOfDayUtc {
    return DateTime.utc(year, month, day, 23, 59, 59);
  }
}
