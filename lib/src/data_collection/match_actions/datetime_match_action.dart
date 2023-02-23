import '../_index.dart';

class DateTimeMatchAction<T> extends MatchAction<T> {
  final DateTime? begin;
  final DateTime? end;
  final DateTime? Function(T)? dateExtractor;

  DateTimeMatchAction({
    required super.key,
    this.begin,
    this.end,
    this.dateExtractor,
  }) : super(
          isEnabled: begin != null || end != null,
          predicate: (item) {
            final createdAt = dateExtractor?.call(item);
            if (createdAt == null) {
              return false;
            }

            final isAfterBegin = begin != null
                ? createdAt.compareTo(begin.onlyDateUtc) >= 0
                : null;
            final isBeforeEnd =
                end != null ? createdAt.compareTo(end.endOfDayUtc) <= 0 : null;

            if (begin != null && end == null) {
              return isAfterBegin!;
            } else if (begin == null && end != null) {
              return isBeforeEnd!;
            } else if (begin != null && end != null) {
              return isAfterBegin! && isBeforeEnd!;
            }

            return false;
          },
        );
}
