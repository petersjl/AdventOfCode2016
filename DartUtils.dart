import 'dart:convert';
import 'package:crypto/crypto.dart';
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

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

// Extensions
extension StringExtras on String{
  List<String> get characters {
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
  int get hashCode => '${x}${y}'.hashCode;

  @override
  operator ==(Object other){
    if(other is! Point) return false;
    return hashCode == other.hashCode;
  }

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

class Binode<T> {
  T value;
  Binode<T>? prev;
  Binode<T>? next;

  Binode(this.value);
}

class Stack<T>{
  int _size;
  int get length => _size;

  bool get isEmpty => _size == 0;

  Binode<T>? _top;
  Binode<T>? _bottom;

  Stack():_size = 0;

  void push(T item){
    Binode<T> node = Binode(item);
    if(_size == 0){
      _top = node;
      _bottom = node;
    }
    else{
      _top!.next = node;
      node.prev = _top;
      _top = node;
    }
    _size++;
  }

  void pushBottom(T item){
    Binode<T> node = Binode(item);
    if(_size == 0){
      _top = node;
      _bottom = node;
    }
    else{
      _bottom!.prev = node;
      node.next = _bottom;
      _bottom = node;
    }
    _size++;
  }

  T pop(){
    if(_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _top!.value;
    if(_size == 1){
      _top = null;
      _bottom = null;
    }
    else{
      _top = _top!.prev;
    }
    _size--;
    return val;
  }

  T popBottom(){
    if(_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _bottom!.value;
    if(_size == 1){
      _top = null;
      _bottom = null;
    }
    else{
      _bottom = _bottom!.next;
    }
    _size--;
    return val;
  }

  @override
  String toString(){
    var buf = StringBuffer('Top{');
    var cur = _top;
    while(cur != null){
      buf.write(cur.value);
      buf.write(',');
      cur = cur.prev;
    }
    var str = buf.toString();
    if(_size > 0) str = str.substring(0, str.length - 1);
    return str + '}Bottom';
  }
}

class Queue<T>{
  int _size;
  int get length => _size;

  bool get isEmpty => _size == 0;

  Binode<T>? _start;
  Binode<T>? _end;

  Queue(): _size = 0;

  void push(T item){
    Binode<T> node = Binode(item);
    if(_size == 0){
      _start = node;
      _end = node;
    }
    else{
      _start!.prev = node;
      node.next = _start;
      _start = node;
    }
    _size++;
  }

  void pushEnd(T item){
    Binode<T> node = Binode(item);
    if(_size == 0){
      _start = node;
      _end = node;
    }
    else{
      _end!.next = node;
      node.prev = _end;
      _end = node;
    }
    _size++;
  }

  T pop(){
    if(_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _end!.value;
    if(_size == 1){
      _start = null;
      _end = null;
    }
    else{
      _end = _end!.prev;
    }
    _size--;
    return val;
  }

  T popStart(){
    if(_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _start!.value;
    if(_size == 1){
      _start = null;
      _end = null;
    }
    else{
      _start = _start!.next;
    }
    _size--;
    return val;
  }

  @override
  String toString(){
    var buf = StringBuffer('Start{');
    var cur = _start;
    while(cur != null){
      buf.write(cur.value);
      buf.write(',');
      cur = cur.next;
    }
    var str = buf.toString();
    if(_size > 0) str = str.substring(0, str.length - 1);
    return str + '}End';
  }
}