import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Object input = File(filePath).readAsStringSync().splitNewLine();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  int count = 0;
  for(String line in parseInput() as List<String>){
    if (checkTriangle(line)) count++;
  }
  print('There are $count possible triangles');
}

bool checkTriangle(String str){
  List<String> strParts = str.split(new RegExp('\\s+'))..removeAt(0);
  List<int> parts = strParts.listMap<int>(((e) => int.parse(e)));
  return parts[0] < parts[1] + parts[2] && parts[1] < parts[0] + parts[2] && parts[2] < parts[0] + parts[1];
}