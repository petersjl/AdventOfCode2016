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
  List<List<bool>> map = [parseInput() as List<bool>];
  int numRows = 40;
  while(map.length < numRows){
    map.add(generateNextRow(map[map.length - 1]));
  }
  for(var line in map){
    var str = StringBuffer();
    for(var tile in line){
      str.write(tile ? '.' : '^');
    }
    print(str);
  }
  int count = 0;
  for(var line in map) for(var tile in line) if(tile) count++;
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
