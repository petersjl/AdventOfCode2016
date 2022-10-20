import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Object input = File(filePath).readAsStringSync().split(", ");
  return input;
}

enum Direction{
  North,
  South,
  East,
  West
}

// The main method of the puzzle solve
void solvePuzzle(){
  List<String> input = parseInput();
  Direction currentDirection = Direction.North;
  Point location = Point(0,0);
  for (String str in input){
    bool turnDir = str[0] == 'R';
    int dist = int.parse(str.substring(1));
    currentDirection = turn(currentDirection, turnDir);
    progress(location, dist, currentDirection);
  }
  print('You need to go ${location.x.abs() + location.y.abs()} steps away');
}

void progress(Point point, int distance, Direction direction){
  switch(direction){
    case Direction.North: point.y += distance; break;
    case Direction.South: point.y -= distance; break;
    case Direction.East: point.x += distance; break;
    case Direction.West: point.x -= distance; break;
  }
}

Direction turn(Direction current, bool isRightTurn){
  switch(current){
    case Direction.North: return isRightTurn ? Direction.East : Direction.West; break;
    case Direction.South: return isRightTurn ? Direction.West : Direction.East; break;
    case Direction.East: return isRightTurn ? Direction.South : Direction.North; break;
    case Direction.West: return isRightTurn ? Direction.North : Direction.South; break;
  }
  return Direction.North;
}