import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  List<String> input = File(filePath).readAsStringSync().splitNewLine();
  var goalString = input[1].split(",");
  return [int.parse(input[0]), new Point(int.parse(goalString[0]), int.parse(goalString[1]))];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var list = parseInput() as List;
  var special = list[0] as int;
  var goal = list[1] as Point;
  var map = generateMap(goal, special);
  var visited = CheckSteps(map, 50, true);
  print('We can reach $visited locations');
}

List<List<bool>> generateMap(Point goal, int special){
  List<List<bool>> map = List.generate((goal.x *1.5).toInt(), (index) => List.generate((goal.y * 1.5).toInt(), (index) => false, growable: false), growable: false);
  for(int x = 0; x < map.length; ++x){
    for(int y = 0; y < map[0].length; ++y){
      map[x][y] = checkSpotOpen(x, y, special);
    }
  }
  return map;
}

bool checkSpotOpen(int x, int y, int special){
  var num = (x*x + 3*x + 2*x*y + y + y*y) + special;
  var str = num.toRadixString(2);
  var count = 0;
  for (String s in str.characters) {
    if(s == "1") count++;
  }
  return count % 2 == 0;
}

int CheckSteps(List<List<bool>> map, int maxSteps, [bool print = false]){
  maxSteps += 1;
  Set<Point> seen = {};
  List<Node<Point>> queue = [];
  queue.add(Node(Point(1,1)));
  seen.add(Point(1,1));
  while(queue.length > 0) {
    var currentNode = queue.removeAt(0);
    var newx = currentNode.value.x - 1;
    var newy = currentNode.value.y;
    if(newx > -1 && map[newx][newy]){
      var node = Node(Point(newx,newy), currentNode);
      if(seen.add(node.value)) {
        if(node.length < maxSteps)
          queue.add(node);
      }
    }
    newx += 2;
    if(newx < map.length && map[newx][newy]){
      var node = Node(Point(newx,newy), currentNode);
      if(seen.add(node.value)) {
        if(node.length < maxSteps)
          queue.add(node);
      }
    }
    newx -= 1;
    newy -= 1;
    if(newy > -1 && map[newx][newy]){
      var node = Node(Point(newx,newy), currentNode);
      if(seen.add(node.value)) {
        if(node.length < maxSteps)
          queue.add(node);
      }
    }
    newy += 2;
    if(newy < map[0].length && map[newx][newy]){
      var node = Node(Point(newx,newy), currentNode);
      if(seen.add(node.value)) {
        if(node.length < maxSteps)
          queue.add(node);
      }
    }
  }
  return seen.length;
}

List<List<String>> stringMap(List<List<bool>> map){
  List<List<String>> strmap = List.generate(map.length, (index) => List.generate(map[0].length, (index) => "", growable: false), growable: false);
  for(int y = 0; y < map[0].length; ++y){
    for(int x = 0; x < map.length; ++x){
      strmap[x][y] = map[x][y] ? "." : "#";
    }
  }
  return strmap;
}

void printStringMap(List<List<String>> map){
  var str = StringBuffer();
  for(int y = 0; y < map[0].length; ++y){
    for(int x = 0; x < map.length; ++x){
      str.write(map[x][y]);
    }
    str.write('\n');
  }
  print(str);
}

class Node<T>{
  T value;
  Node<T>? parent;
  Node(this.value, [this.parent]);

  int get length{
    if(parent == null) return 1;
    else return 1 + parent!.length;
  }
}