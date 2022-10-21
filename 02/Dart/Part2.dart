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
  Point num = new Point(2, 0);
  String code = '';
  for (String line in input){
    num = getButton(num, line);
    code += getButtonVal(num);
  }
  print('The bathroom code is $code');
}

Point getButton(Point startButton, String instructions){
  int row = startButton.x;
  int col = startButton.y;
  
  for (String s in instructions.characters){
    int newRow = row;
    int newCol = col;
    switch(s){
      case 'U': newRow--; break;
      case 'D': newRow++; break;
      case 'L': newCol--; break;
      case 'R': newCol++; break;
      case '\n': continue;
      default:
        print('Invalid character in getButton: $s');
        continue;
        break;
    }
    if(getButtonVal(new Point(newRow, newCol)) != null){
      row = newRow;
      col = newCol;
    }
  }
  return new Point(row, col);
}

String getButtonVal(Point button){
  switch(button.x){
    case 0: return button.y == 2 ? '1' : null;
    case 1: return button.y > 0 && button.y < 4 ? (button.y + 1).toString() : null;
    case 2: return button.y > -1 && button.y < 5 ? (button.y + 5).toString() : null;
    case 3: 
      switch(button.y){
        case 1: return 'A'; break;
        case 2: return 'B'; break;
        case 3: return 'C'; break;
        default: return null;
      } break;
    case 4: return button.y == 2 ? 'D' : null;
    default: return null;
  }
}