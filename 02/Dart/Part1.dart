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
  List<String> input = parseInput();
  int num = 5;
  String code = '';
  for (String line in input){
    num = getButton(num, line);
    if (num == -1) return;
    code += num.toString();
  }
  print('The bathroom code is $code');
}

int getButton(int startButton, String instructions){
  int col = (startButton - 1) % 3;
  int row = (startButton - 1) ~/ 3;
  for (String s in instructions.characters){
    switch(s){
      case 'U': row--; break;
      case 'D': row++; break;
      case 'L': col--; break;
      case 'R': col++; break;
      case '\n': continue;
      default:
        print('Invalid character in getButton: $s');
        continue;
        break;
    }
    if (row < 0) row = 0;
    else if (row > 2) row = 2;
    if (col < 0) col = 0;
    else if (col > 2) col = 2;
  }
  return row * 3 + col + 1;
}