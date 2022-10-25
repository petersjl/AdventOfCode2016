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
  List<Pair> queue = [new Pair(input, 1)];
  int totalLength = 0;
  while(!queue.isEmpty){
    var current = queue.removeAt(0);
    for(int i = 0; i < current.piece.length; ++i){
      String char = current.piece[i];
      if(char == '('){
        ++i;
        int end = current.piece.indexOf(')', i);
        List<int> parts = current.piece.substring(i, end).split('x').listMap((e) => int.parse(e));
        var subStart = end + 1;
        var subEnd = end + 1 + parts[0];
        queue.add(new Pair(current.piece.substring(subStart, subEnd), current.multiplier * parts[1]));
        i = end + parts[0];
      }
      else{
        totalLength += current.multiplier;
      }
    }
  }
  print('The decompressed file has length $totalLength');
}

void addExtra(String input, StringBuffer buffer, int start, int len, int count){
  String str = input.substring(start, start + len);
  for(int i = 0; i < count; ++i) buffer.write(str);
}

class Pair{
  String piece;
  int multiplier;
  
  Pair(this.piece, this.multiplier);
}