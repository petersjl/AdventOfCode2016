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
  List<String> input = parseInput() as List<String>;
  int runs = input[0].length;
  String message = '';
  for (int i = 0; i < runs; i++){
    message += findMostCommonAtPosition(input, i);
  }
  print('The message is $message');
}

String findMostCommonAtPosition(List<String> input, int index){
  Map<String, int> map = {};
  for (String s in input){
    String char = s[index];
    map.increment(char);
  }
  String minChar = '';
  int min = 1000000;
  for (String char in map.keys){
    if (map[char]! < min){
      min = map[char]!;
      minChar = char;
    }
  }
  return minChar;
}