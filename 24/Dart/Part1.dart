import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine();
  var colLength = input.removeAt(0).length;
  input.removeAt(input.length - 1);
  List<List<bool>> map = [];
  map.add(List.filled(colLength, false));
  Point startPos = Point(-1,-1);
  List<Target> targets = [];
  int row = 1;
  for(var line in input){
    int col = 0;
    List<bool> boolRow = List.filled(colLength, false);
    for(var char in line.characters){
      var check = int.tryParse(char);
      if(check != null){
        if(check == 0) startPos = Point(col,row);
        else targets.add(Target(row, col, check));
        boolRow[col] = true;
      }
      else{
        boolRow[col] = check == ".";
      }
      col++;
    }
    row++;
  }
  map.add(List.filled(colLength, false));
  return [map,targets,startPos];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var input = parseInput() as List;
  var map = input[0] as List<List<bool>>;
  var targets = input[1] as List<Target>;
  var startPos = input[2] as Point;
  
  for(var t in targets) print(t);
}

class Target{
  int row;
  int col;
  int val;

  Target(this.row, this.col, this.val);

  @override
  String toString() {
    return "$row, $col, $val";
  }
}