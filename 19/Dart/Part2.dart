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
  Stack<int> firstHalf = Stack();
  Queue<int> secondHalf = Queue();
  for(int i = 1; i < count ~/ 2 + 1; ++i) firstHalf.push(i);
  for(int i = count ~/2 + 1; i <= count; ++i) secondHalf.push(i);
  while(!secondHalf.isEmpty){
    firstHalf.length > secondHalf.length ? firstHalf.pop() : secondHalf.pop();
    secondHalf.push(firstHalf.popBottom());
    firstHalf.push(secondHalf.pop());
  }
  print('All presents go to elf number ${firstHalf.pop()}');
}