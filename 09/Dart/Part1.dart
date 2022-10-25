import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Object input = File(filePath).readAsStringSync();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  String input = parseInput() as String;
  StringBuffer buffer = new StringBuffer();
  for(int i = 0; i < input.length; ++i){
    String char = input[i];
    if(char == '('){
      ++i;
      int end = input.indexOf(')', i);
      List<int> parts = input.substring(i, end).split('x').listMap((e) => int.parse(e));
      addExtra(input, buffer, end + 1, parts[0], parts[1]);
      i = end + parts[0];
    }
    else{
      buffer.write(char);
    }
  }
  var str = buffer.toString();
  print('The decompressed string has length ${str.length}');
}

void addExtra(String input, StringBuffer buffer, int start, int len, int count){
  String str = input.substring(start, start + len);
  for(int i = 0; i < count; ++i) buffer.write(str);
}