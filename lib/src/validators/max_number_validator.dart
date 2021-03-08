import 'package:form_validation/form_validation.dart';
import 'package:json_class/json_class.dart';
import 'package:meta/meta.dart';
import 'package:static_translations/static_translations.dart';

@immutable
class MaxNumberValidator extends JsonClass implements ValueValidator {
  /// Constructs the validator with the maximum [number] that the value may be.
  MaxNumberValidator({
    required this.number,
  });

  static const type = 'max_number';

  final double number;

  /// Processes the validator object from the given [map] which must be an
  /// actual Map or a Map-like object that supports the `[]` operator.  Any
  /// non-null object that is not Map-like will result in an error.  A [null]
  /// value will result in a return value of [null].
  ///
  /// This expects the JSON format:
  /// ```json
  /// {
  ///   "length": <number>,
  ///   "type": "max_number"
  /// }
  /// ```
  static MaxNumberValidator fromDynamic(dynamic map) {
    MaxNumberValidator result;

    if (map == null) {
      throw Exception('[MaxNumberValidator.fromDynamic]: map is null');
    } else {
      assert(map['type'] == type);

      result = MaxNumberValidator(
        number: JsonClass.parseDouble(
              map['number'],
            ) ??
            0,
      );
    }

    return result;
  }

  /// Returns the JSON-compatible representation of this validator.
  @override
  Map<String, dynamic> toJson() => {
        'number': number,
        'type': type,
      };

  /// Ensures the value is a valid number that is at no larger than the assigned
  /// [number].
  ///
  /// This will pass on empty or [null] values.
  ///
  /// See also:
  ///  * [FormValidationTranslations.form_validation_max_number]
  ///  * [FormValidationTranslations.form_validation_number]
  @override
  String? validate({
    required String label,
    required Translator translator,
    required String? value,
  }) {
    String? error;

    if (value?.isNotEmpty == true) {
      var numValue = JsonClass.parseDouble(value);

      if (numValue == null) {
        error = translator.translate(
          FormValidationTranslations.form_validation_number,
          {
            'label': label,
          },
        );
      } else if (numValue > number) {
        error = translator.translate(
          FormValidationTranslations.form_validation_max_number,
          {
            'label': label,
            'number': number,
          },
        );
      }
    }

    return error;
  }
}
