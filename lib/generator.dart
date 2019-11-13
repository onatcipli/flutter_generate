import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_generate/file_model.dart';
import 'package:flutter_generate/structure.dart';
import 'package:recase/recase.dart';

/// This is an defaultGenerator which takes [defaultStructure] as an parameter.
Generator defaultGenerator = Generator(currentStructure: defaultStructure);

/// Generator takes an [Structure] object, to specify where to create .dart files
class Generator {
  final Structure currentStructure;

  Generator({
    this.currentStructure,
  }) : assert(currentStructure != null);

  /// This method creates the file in expected path and writes inside a file as expected.
  ///
  /// if user do not write --stful flag the files which will be created will extend from StatelessWidget
  ///
  ///
  ///       flutter_generate page --name LoginPage --stful
  ///
  /// the following is same
  ///
  ///       flutter_generate page --name LoginPage
  ///
  ///       flutter_generate page --name LoginPage  --stless
  ///
  Future handleFileCreate(ArgResults results,
      {bool isOnlyClass = false}) async {
    await defaultGenerator.createFile(
        fileModel: FileModel(
      result: results['name'],
      path: Structure.getPathWithName(
        defaultStructure.getPathByKey(results.command.name),
        ReCase(results['name']).snakeCase,
        createWithWrappedFolder: results['extraFolder'],
      ),
      commandName: results.command.name,
      isStateful: results.command['stful'],
      isOnlyClass: isOnlyClass,
    ));
  }

  /// This function only handles file creation
  Future<File> createFile({FileModel fileModel}) async {
    ReCase reCase = ReCase(fileModel.result);
    File _file = await File(fileModel.path + ".dart").create(recursive: true);

    if (fileModel.isOnlyClass) {
      await _file.writeAsString(getOnlyClass(reCase.pascalCase));
    } else {
      await _file.writeAsString(
        fileModel.isStateful
            ? getStateFul(reCase.pascalCase)
            : getStateLess(reCase.pascalCase),
      );
    }
    print(
        "file created succesfully with name :${fileModel.result} at path: ${fileModel.path}");
    return _file;
  }

  String getBlocExporter(String fileName) {
    return '''
export '${fileName}_bloc.dart';
export '${fileName}_event.dart';
export '${fileName}_state.dart';

''';
  }

  String getBloc(String fileName) {
    return '''
import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ${fileName}Bloc extends Bloc<${fileName}Event, ${fileName}State> {
  @override
  ${fileName}State get initialState => Initial${fileName}State();

  @override
  Stream<${fileName}State> mapEventToState(
    ${fileName}Event event,
  ) async* {
    // TODO: Add Logic
  }
}

''';
  }

  String getBlocState(String fileName) {
    return '''
import 'package:equatable/equatable.dart';

abstract class ${fileName}State extends Equatable {
  const ${fileName}State();
}

class Initial${fileName}State extends ${fileName}State {
  @override
  List<Object> get props => [];
}

''';
  }

  String getBlocEvent(String fileName) {
    return '''
import 'package:equatable/equatable.dart';

abstract class ${fileName}Event extends Equatable {
  const ${fileName}Event();
}

''';
  }

  /// this function returns a String for creating only Class with specified name
  String getOnlyClass(String fileName) {
    return '''

class ${fileName} {

  ${fileName}();

}
    ''';
  }

  /// This function returns a String with specified class name which extends from StatelessWidget
  String getStateLess(String fileName) {
    return '''
import 'package:flutter/material.dart';

class ${fileName} extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
  ''';
  }

  /// This function returns a String with specified class name which extends from StatefulWidget
  String getStateFul(String fileName) {
    return '''
import 'package:flutter/material.dart';

class ${fileName} extends StatefulWidget {

  @override
  _${fileName}State createState() => _${fileName}State();
}

class _${fileName}State extends State<${fileName}> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
  ''';
  }

  Future<void> createBloc(ArgResults results) async {
    FileModel _fileModel = FileModel(
      result: results['name'],
      path: Structure.getPathWithName(
        defaultStructure.getPathByKey(results.command.name),
        ReCase(results['name']).snakeCase,
        createWithWrappedFolder: true,
      ),
      commandName: results.command.name,
      isBloc: true,
    );
    ReCase reCase = ReCase(_fileModel.result);
    File _bloc =
        await File(_fileModel.path + "_bloc.dart").create(recursive: true);
    await _bloc.writeAsString(getBloc(reCase.pascalCase));
    File _event =
        await File(_fileModel.path + "_event.dart").create(recursive: true);
    await _event.writeAsString(getBlocEvent(reCase.pascalCase));
    File _state =
        await File(_fileModel.path + "_state.dart").create(recursive: true);
    await _state.writeAsString(getBlocState(reCase.pascalCase));
    File _blocExporter = await File(_fileModel.path.substring(
                0, _fileModel.path.length - reCase.snakeCase.length) +
            "bloc.dart")
        .create(recursive: true);
    await _blocExporter.writeAsString(getBlocExporter(reCase.snakeCase));
    print(reCase.pascalCase + " bloc created succesfully.");
  }
}

/// This function takes the results from the [ArgParser] and act as expected.
Future<void> generate({
  ArgResults results,
  Generator generator,
}) async {
  switch (results.command.name) {
    case "page":
      await generator.handleFileCreate(results);
      break;
    case "widget":
      await generator.handleFileCreate(results);
      break;
    case "repository":
      await generator.handleFileCreate(results, isOnlyClass: true);
      break;
    case "model":
      await generator.handleFileCreate(results, isOnlyClass: true);
      break;
    case "bloc":
      await generator.createBloc(results);
      break;
  }
}
