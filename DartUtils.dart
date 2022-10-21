import 'package:path/path.dart' as Path;
import 'dart:io' show Platform;

// Random utilites methods
class Utils{
  static String to_abs_path(path,[base_dir = null]){
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
}

// Extensions
extension StringExtras on String{
  Iterable get characters {
    return this.split('');
  }

  List<String> splitNewLine(){
    return this.split('\r\n');
  }
}

extension ListMap on List{
  List<T> listMap<T>(Function fun){
    List<T> list = [];
    for (Object e in this){
      list.add(fun(e));
    }
    return list;
  }
}

// Classes
class Point{
  int x, y;
  Point(this.x, this.y);

  @override
  String toString(){
    return '${this.x}, ${this.y}';
  }
}