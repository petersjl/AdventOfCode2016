import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  List<bool> input = File(filePath).readAsStringSync().characters.listMap<bool>((char) => char == '.');
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var line = parseInput() as List<bool>;
  int numRows = 400000;
  int index = 1;
  int count = 0;
  for(var tile in line) if(tile) count++;
  while(index < numRows){
    var newLine = generateNextRow(line);
    for(var tile in newLine) if(tile) count++;
    line = newLine;
    index++;
  }
  print('There are $count safe tiles');
}

List<bool> generateNextRow(List<bool> line) {
  return List.generate(line.length, (index) {
    bool left = (index == 0) || line[index - 1];
    bool right = (index == line.length - 1) || line[index + 1];
    bool center = line[index];
    return !((left && center && !right) || (!left && !center && right) || (left && !center && !right) || (!left && center && right));
  });
}

void printLine(List<bool> line){
  var buf = StringBuffer();
  for(var c in line){
    buf.write(c ? '.' :'^');
  }
  print(buf);
}
