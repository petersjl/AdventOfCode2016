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

extension GenericListExtras on List{
  List<T> listMap<T>(Function fun){
    List<T> list = [];
    for(Object e in this){
      list.add(fun(e));
    }
    return list;
  }

  List<T> listWhere<T>(bool fun(element)){
    List<T> list = [];
    for(T e in this){
      if(fun(e)) list.add(e);
    }
    return list;
  }

  dynamic whereFirst(bool fun(element)){
    for(Object e in this) if(fun(e)) return e;
    return null;
  }
}

extension MapExtras on Map<dynamic, int>{
  int increment(dynamic key){
    return update(key, (value) => ++value, ifAbsent:() => 1);
  }
}

extension GenericMapExtras on Map<dynamic, dynamic>{
  bool where(bool test(dynamic key, dynamic value)){
    for(MapEntry entry in this.entries){
      if(test(entry.key, entry.value)) return true;
    }
    return false;
  }
  
  dynamic whereFirst(bool test(dynamic key, dynamic value)){
    for(MapEntry entry in this.entries){
      if(test(entry.key, entry.value)) return entry.value;
    }
    return null;
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

class Pair<T1, T2> extends Object{
  T1 first;
  T2 second;
  int get length => 2;

  @override
  int get hashCode => '${first.hashCode}${second.hashCode}'.hashCode;

  Pair(this.first, this.second);

  operator [](int index){
    if(index == 0) return first;
    if(index == 1) return second;
    throw IndexError(index, this);
  }
  
  @override
  operator ==(Object other){
    if(other is! Pair) return false;
    return first == other.first 
        && second == other.second;
  }

  @override
  String toString(){
    return '($first, $second)';
  }
}

class PriorityQueue<T>{
  int _size = 0;
  List<T> _array;
  Function _comparator;

  int get length => _size;

  PriorityQueue(int fun(T queueItem,T toInsert)): _comparator = fun, _array = [];

  void enqueue(T object){
    for(int i = 0; i < _array.length; ++i){
      T thing = _array[i];
      if(0 < _comparator(thing, object)){
        _array.insert(i, object);
        _size++;
        return;
      }
    }
    _array.add(object);
    _size++;
    return;
  }

  T dequeue(){
    _size--;
    return _array.removeAt(0);
  }

  void clear(){
    _array.clear();
    _size = 0;
  }

  @override
  String toString(){
    StringBuffer str = StringBuffer('[');
    str.writeAll(_array, ',');
    str.write(']');
    return str.toString();
  }
}