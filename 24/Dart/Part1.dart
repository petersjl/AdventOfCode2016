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
  List<List<int>> map = [];
  map.add(List.filled(colLength, -1));
  List<Target> targets = [];
  int row = 1;
  for(var line in input){
    int col = 0;
    List<int> boolRow = List.filled(colLength, -1);
    for(var char in line.characters){
      var check = int.tryParse(char);
      if(check != null){
        targets.add(Target(row, col, check));
        boolRow[col] = 1;
      }
      else{
        boolRow[col] = char == "." ? 0 : -1;
      }
      col++;
    }
    row++;
    map.add(boolRow);
  }
  map.add(List.filled(colLength, -1));
  return [map,targets];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var input = parseInput(true) as List;
  var map = input[0] as List<List<int>>;
  var targets = input[1] as List<Target>;
  
  Map<int,Map<int,int>> allPaths = {};
  for(var target in targets){
    var currentTargets = targets.listWhere<Target>((element) => element != target);
    currentTargets.remove(target);
    allPaths[target.val] = bfs(Point(target.col, target.row), currentTargets, map);
  }

  print(allPaths);
}

Map<int,int> bfs(Point startingPos, List<Target> targets, List<List<int>> map){
  List<Point> seen = [startingPos];
  Queue<Pair<Point, int>> queue = Queue();
  queue.push(new Pair(startingPos, 0));
  Map<int,int> paths = {};
  while(!queue.isEmpty && !targets.isEmpty){
    Pair current = queue.pop();
    int newLen = current.second + 1;
    Point currentPos = current.first;
    Point up = Point(currentPos.x, currentPos.y - 1);
    Point down = Point(currentPos.x, currentPos.y + 1);
    Point left = Point(currentPos.x - 1, currentPos.y);
    Point right = Point(currentPos.x + 1, currentPos.y);
    handlePoint(map, targets, queue, seen, paths, newLen, up);
    handlePoint(map, targets, queue, seen, paths, newLen, down);
    handlePoint(map, targets, queue, seen, paths, newLen, left);
    handlePoint(map, targets, queue, seen, paths, newLen, right);
  }
  return paths;
}

void handlePoint(
  List<List<int>> map, 
  List<Target> targets, 
  Queue<Pair<Point, int>> queue, 
  List<Point> seen, 
  Map<int,int> paths,
  int newLen, 
  Point newPoint){
  var mapVal = map[newPoint.y][newPoint.x];
  if(mapVal != -1 && !seen.contains(newPoint)){
    if(mapVal == 1){
      Target? t = targetsContain(targets, newPoint);
      if(t != null){
        paths[t.val] = newLen;
        targets.remove(t);
      }
    }
    seen.add(newPoint);
    queue.push(Pair(newPoint, newLen));
  }
}

Target? targetsContain(List<Target> targets, Point point){
  var found = targets.listWhere<Target>((Target element) => element.row == point.y && element.col == point.x);
  return found.length > 0 ? found[0] : null;
}

class Target{
  int row;
  int col;
  int val;

  Target(this.row, this.col, this.val);

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    return "$row, $col, $val";
  }
}