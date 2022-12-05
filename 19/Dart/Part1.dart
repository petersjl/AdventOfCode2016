import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync();
  return int.parse(input);
}

// The main method of the puzzle solve
void solvePuzzle(){
  var count = parseInput() as int;
  List<bool> elves = List.generate(count, (index) => true);
  int index = 0;
  while(count > 1){
    while(!elves[index]){
      index++;
      if(index >= elves.length) index = 0;
    }
    index++;
    if(index >= elves.length) index = 0;
    while(!elves[index]){
      index++;
      if(index >= elves.length) index = 0;
    }
    elves[index] = false;
    count--;
    index++;
    if(index >= elves.length) index = 0;
  }
  print('All presents go to elf number ${elves.indexOf(true)+1}');
}