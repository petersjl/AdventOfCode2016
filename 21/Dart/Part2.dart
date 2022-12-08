import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput2.txt' : '../input2.txt');
  var input = File(filePath).readAsStringSync().splitNewLine();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var instructions = parseInput() as List<String>;
  var str = instructions.removeAt(0).characters;
  var lookup = generateLookup(str.length);
  for(var line in instructions.reversed){
    var parts = line.split(' ');
    switch(parts[0]){
      case 'swap':
        if(parts[1] == 'position') swapPosition(str, int.parse(parts[2]), int.parse(parts[5]));
        else swapLetter(str, parts[2], parts[5]);
        break;
      case 'rotate':
        switch(parts[1]){
          case 'left': rotate(str, int.parse(parts[2]), true); break;
          case 'right': rotate(str, int.parse(parts[2])); break;
          default: rotateOn(str, parts[6],lookup); break;
        }
        break;
      case 'reverse': reverse(str, int.parse(parts[2]), int.parse(parts[4])); break;
      case 'move': move(str, int.parse(parts[2]), int.parse(parts[5])); break;
      default: throw StateError('Invalid command ${parts[0]}');
    }
  }
  var buf = StringBuffer();
  for(var c in str) buf.write(c);
  print(buf);
}

void swapPosition(List<String> str, int x, int y){
  var hold = str[x];
  str[x] = str[y];
  str[y] = hold;
}

void swapLetter(List<String> str, String x, String y){
  swapPosition(str, str.indexOf(x), str.indexOf(y));
}

void rotate(List<String> str, int count, [bool left = false]){
  for(int i = 0; i < count; ++i){
    if(!left) str.add(str.removeAt(0));
    else str.insert(0, str.removeLast());
  }
}

void rotateOn(List<String> str, String char, Map<int,int> lookup){
  int index = str.indexOf(char);
  rotate(str, lookup[index]!);
}

Map<int,int> generateLookup(int size){
  Map<int,int> lookup = {};
  for(int i = 0; i< size; i++){
    int dist = (i + (i > 3 ? 2 : 1));
    lookup[(i+dist)%size] = dist;
  }
  return lookup;
}

void reverse(List<String> str, int start, int end){
  int count = end - start + 1;
  Queue queue = Queue();
  while(count > 0){
    queue.push(str.removeAt(start));
    count--;
  }
  while(!queue.isEmpty){
    str.insert(start, queue.pop());
  }
}

void move(List<String> str, int x, int y){
  str.insert(x, str.removeAt(y));
}