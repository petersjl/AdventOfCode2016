import 'package:path/path.dart' as Path;
import 'dart:io' show Platform;

String to_abs_path(path,[base_dir = null]){
  Path.Context context;
  if(Platform.isWindows){
    context = new Path.Context(style:Path.Style.windows);
  }else{
    context = new Path.Context(style:Path.Style.posix);
  }
  base_dir ??= Path.dirname(Platform.script.toFilePath());
  path = context.join( base_dir,path);
  return context.normalize(path);
}

extension StringExtras on String{
  Iterable get characters {
    return this.split('');
  }

  List<String> splitNewLine(){
    return this.split('\r\n');
  }
}