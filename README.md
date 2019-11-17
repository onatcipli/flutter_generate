![Icon](https://github.com/onatcipli/flutter_generate/blob/master/flutter_generate.png)

A simple executable command-line application
that helps you to create a consistent structure in your project lib directory It is creating 
dart files with command-line commands and It is compatible with [effective_dart_style](https://dart.dev/guides/language/effective-dart/style) guide.

able to create files from the command line
````
pub global activate flutter_generate 

flutter_generate bloc --name Authentication 

flutter_generate page --name login --stful

flutter_generate widget --name UserCard --stless

flutter_generate repository --name authentication

flutter_generate model --name user_model
````

![Example Image Creating Files](https://github.com/onatcipli/flutter_generate/blob/master/flutter_generate_creating_files.png)


![Example Image](https://github.com/onatcipli/flutter_generate/blob/master/flutter_generate_package_structure.png)

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
