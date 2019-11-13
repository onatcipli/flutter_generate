import 'dart:io';

/// this class includes default paths
Structure defaultStructure = Structure();

/// You able to create a your own structure with this class
/// Just create a new instance an pass it to [Generator]
class Structure {
  String pagesPath;
  String widgetsPath;
  String modelsPath;
  String repositoriesPath;
  String blocsPath;

  Structure({
    this.pagesPath = 'lib/pages/',
    this.widgetsPath = 'lib/widgets/',
    this.modelsPath = 'lib/models/',
    this.repositoriesPath = 'lib/repositories/',
    this.blocsPath = 'lib/blocs/',
  })  : assert(pagesPath != null),
        assert(widgetsPath != null),
        assert(modelsPath != null),
        assert(repositoriesPath != null),
        assert(blocsPath != null) {
    pagesPath = replaceAsExpected(path: pagesPath);
    widgetsPath = replaceAsExpected(path: widgetsPath);
    modelsPath = replaceAsExpected(path: modelsPath);
    repositoriesPath = replaceAsExpected(path: repositoriesPath);
    blocsPath = replaceAsExpected(path: blocsPath);
  }

  Map<String, String> toMap() => {
        "page": pagesPath,
        "widget": widgetsPath,
        "model": modelsPath,
        "repository": repositoriesPath,
        "bloc": blocsPath,
      };

  /// Get file paths with key such as: page, widget, repository, model and more...
  String getPathByKey(String key) {
    return this.toMap()[key];
  }

  // ignore: missing_return
  static String replaceAsExpected({String path, String replaceChar}) {
    if (path.contains("\\")) {
      if (Platform.isLinux || Platform.isMacOS) {
        return path.replaceAll("\\", "/");
      }
    } else if (path.contains("/")) {
      if (Platform.isWindows) {
        return path.replaceAll("/", "\\\\");
      }
    } else {
      return path;
    }
  }

  // ignore: missing_return
  static String getPathWithName(String firstPath, String secondPath,
      {bool createWithWrappedFolder = false}) {
    String betweenPaths;
    if (Platform.isWindows) {
      betweenPaths = "\\\\";
    } else if (Platform.isMacOS || Platform.isLinux) {
      betweenPaths = "/";
    }
    if (betweenPaths.isNotEmpty) {
      if (createWithWrappedFolder) {
        return firstPath +
            betweenPaths +
            secondPath +
            betweenPaths +
            secondPath;
      } else {
        return firstPath + betweenPaths + secondPath;
      }
    }
  }
}
