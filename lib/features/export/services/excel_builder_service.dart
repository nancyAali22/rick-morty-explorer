import 'package:excel/excel.dart';
import '../../characters/domain/entities/character_entity.dart';

/// Turns a list of [CharacterEntity] into the raw bytes of an .xlsx
/// workbook. Deliberately has zero I/O — no file system, no platform
/// channels — so it stays a pure function that can be unit tested with
/// plain Dart objects, no mocking required.
class ExcelBuilderService {
  static const String _sheetName = 'Characters';

  /// Column choice, in order:
  /// ID, Name, Status, Species, Type, Gender, Origin, Location.
  /// These are exactly the descriptive fields a reviewer scanning the
  /// sheet cares about. `image`, `episode` and `url` are intentionally
  /// left out — a raw image link or an array of episode URLs doesn't
  /// read well as a flat spreadsheet cell and adds noise, not signal.
  static const List<String> _headers = [
    'ID',
    'Name',
    'Status',
    'Species',
    'Type',
    'Gender',
    'Origin',
    'Location',
  ];

  List<int> build(List<CharacterEntity> characters) {
    final Excel workbook = Excel.createExcel();

    // Excel.createExcel() ships with one default sheet named 'Sheet1'.
    // Renaming it (instead of creating a new sheet and deleting the
    // default one) keeps the workbook to a single, correctly named tab.
    final Sheet sheet = workbook['Sheet1'];
    workbook.rename('Sheet1', _sheetName);

    _writeHeaderRow(sheet);
    _writeDataRows(sheet, characters);
    _autoSizeColumns(sheet);

    final List<int>? bytes = workbook.encode();
    if (bytes == null) {
      throw const FormatException('Failed to encode the Excel workbook.');
    }
    return bytes;
  }

  void _writeHeaderRow(Sheet sheet) {
    // Brand primary brown (AppColors.primaryBrown = 0xFF8A6D55) so the
    // exported file still feels like it came from this app, not a
    // generic spreadsheet tool.
    final CellStyle headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.white,
      backgroundColorHex: ExcelColor.fromHexString('FF8A6D55'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    for (int col = 0; col < _headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.value = TextCellValue(_headers[col]);
      cell.cellStyle = headerStyle;
    }
  }

  void _writeDataRows(Sheet sheet, List<CharacterEntity> characters) {
    for (int row = 0; row < characters.length; row++) {
      final CharacterEntity character = characters[row];
      final int rowIndex = row + 1; // row 0 is the header

      final List<CellValue> values = <CellValue>[
        IntCellValue(character.id),
        TextCellValue(character.name),
        TextCellValue(character.status),
        TextCellValue(character.species),
        TextCellValue(character.type.isEmpty ? '—' : character.type),
        TextCellValue(character.gender),
        TextCellValue(character.origin.name),
        TextCellValue(character.location.name),
      ];

      for (int col = 0; col < values.length; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex))
            .value = values[col];
      }
    }
  }

  void _autoSizeColumns(Sheet sheet) {
    for (int col = 0; col < _headers.length; col++) {
      sheet.setColumnAutoFit(col);
    }
  }
}
