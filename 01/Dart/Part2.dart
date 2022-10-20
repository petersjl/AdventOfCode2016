import 'dart:io';
import '../../DartUtils.dart' as Utils;

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

class Point{
  int x, y;
  Point(this.x, this.y);

  @override
  String toString(){
    return '${this.x}, ${this.y}';
  }

  int get hashCode => 100000 * this.x + this.y;
}

// The main method of the puzzle solve
void solvePuzzle(){
  List<String> input = parseInput();
  Direction currentDirection = Direction.North;
  Set<int> visited = new Set();
  Point location = Point(0,0);
  visited.add(location.hashCode);
  for (String str in input){
    bool turnDir = str[0] == 'R';
    int dist = int.parse(str.substring(1));
    currentDirection = turn(currentDirection, turnDir);
    if(progress(location, dist, currentDirection, visited)) break;
  }
  print('${location.x}, ${location.y}');
  print('The first location visited twice is ${location.x.abs() + location.y.abs()} steps away');
}

bool progress(Point point, int distance, Direction direction, Set<int> visited){
  var func = ()=>1;
  switch(direction){
    case Direction.North: func =() => point.y += 1; break;
    case Direction.South: func =() => point.y -= 1; break;
    case Direction.East: func =() => point.x += 1; break;
    case Direction.West: func =() => point.x -= 1; break;
  }
  for(int i = 0; i < distance; i++){
    func();
    if (!visited.add(point.hashCode)) return true;
  }
  return false;
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