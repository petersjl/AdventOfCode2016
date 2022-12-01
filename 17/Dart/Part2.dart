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
  var code = parseInput() as String;
  List<String> characters = ['b','c','d','e','f'];
  List<Pair<Point, String>> queue = [];
  queue.add(Pair(Point(0, 0), ""));
  PriorityQueue<String> paths = PriorityQueue((queueItem, toInsert) => toInsert.length - queueItem.length,);
  while(queue.length != 0){
    var currentPair = queue.removeAt(0);
    var pos = currentPair.first;
    var moves = currentPair.second;
    var hash = Utils.generateMd5(code + moves);
    if(pos.y > 0 && characters.contains(hash[0])){
      var found = addNewPoint(pos, queue, moves + "U", y: -1);
      if(found != null) paths.enqueue(found);
    }
    if(pos.y < 3 && characters.contains(hash[1])){
      var found = addNewPoint(pos, queue, moves + "D", y: 1);
      if(found != null) paths.enqueue(found);
    }
    if(pos.x > 0 && characters.contains(hash[2])){
      var found = addNewPoint(pos, queue, moves + "L", x: -1);
      if(found != null) paths.enqueue(found);
    }
    if(pos.x < 3 && characters.contains(hash[3])){
      var found = addNewPoint(pos, queue, moves + "R", x: 1);
      if(found != null) paths.enqueue(found);
    }
  }
  print('The longest path is ${paths.dequeue().length}');
}

String? addNewPoint(Point current, List<Pair<Point,String>> list, String moves, {int x = 0, int y = 0}){
  var newPoint = Point(current.x + x, current.y + y);
  if(newPoint.x == 3 && newPoint.y == 3)
    return moves;
  list.add(Pair(newPoint, moves));
  return null;
}