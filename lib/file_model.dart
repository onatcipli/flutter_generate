class FileModel {
  final String result;
  final String path;
  final String commandName;
  final bool isBloc;
  final bool isOnlyClass;
  final bool isStateful;

  FileModel(
      {this.result,
      this.path,
      this.commandName,
      this.isOnlyClass = false,
      this.isBloc = false,
      this.isStateful});
}
