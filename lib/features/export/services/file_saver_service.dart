import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Handles everything I/O-related: turning encoded bytes into a real
/// file on disk, in the correct app-sandboxed directory. Kept separate
/// from [ExcelBuilderService] on purpose — building the workbook (pure)
/// and saving it (I/O) are two different responsibilities, and this
/// split lets each be reasoned about (and tested) independently.
///
/// Platform notes — why no runtime permission is requested here:
/// On Android 10+ (API 29+), scoped storage blocks direct writes to
/// shared/public storage (e.g. the Downloads folder) unless the app
/// either uses the Storage Access Framework file picker or declares the
/// broad `MANAGE_EXTERNAL_STORAGE` permission — the latter gets flagged
/// in Play Store review for apps that don't strictly need it, and is
/// overkill for a "export my own data" button.
/// Writing to the app's own documents directory
/// (`getApplicationDocumentsDirectory`) instead needs **no runtime
/// permission at all**, on Android or iOS — it's private app storage by
/// definition. `open_file` can still hand that file to any other app
/// (Excel, Sheets, WhatsApp, …) via Android's FileProvider / iOS's
/// document interaction controller, so the user can view or share it
/// from there. That's why `permission_handler` isn't invoked by this
/// feature — this path simply doesn't need it.
class FileSaverService {
  Future<File> save(List<int> bytes, {required String fileName}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$fileName';
    final File file = File(path);
    return file.writeAsBytes(bytes, flush: true);
  }

  /// Timestamped so repeated exports never overwrite each other.
  String buildFileName() {
    final DateTime now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final String stamp =
        '${now.year}${two(now.month)}${two(now.day)}_${two(now.hour)}${two(now.minute)}${two(now.second)}';
    return 'rick_morty_characters_$stamp.xlsx';
  }
}
