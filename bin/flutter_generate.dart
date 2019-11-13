import 'package:args/args.dart';
import 'package:flutter_generate/flutter_generate.dart';

main(List<String> arguments) {
  final ArgParser argParser = ArgParser();

  argParser.addOption("name", abbr: "n");
  argParser.addFlag("extraFolder", abbr: "e", defaultsTo: false);

  final widgetParser = ArgParser();
  widgetParser.addFlag("stful", defaultsTo: false);
  widgetParser.addFlag("stless", defaultsTo: false);

  argParser.addCommand("page", widgetParser);
  argParser.addCommand("widget", widgetParser);

  argParser.addCommand("model", widgetParser);
  argParser.addCommand("repository", widgetParser);

  final blocParser = ArgParser();
  widgetParser.addFlag("equatable", defaultsTo: true);
  argParser.addCommand("bloc", blocParser);

  ArgResults results = argParser.parse(arguments);

  generate(generator: defaultGenerator, results: results);
}
