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
  var steps = aStar(map, goal, true);
  print('Get to goal in ${steps - 1} steps');
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

int aStar(List<List<bool>> map, Point goal, [bool print = false]){
  Set<Point> seen = {};
  PriorityQueue queue = PriorityQueue<Node<Point>>((queueItem, toInsert) {
    int qDist = (queueItem.value.x - goal.x).abs() + (queueItem.value.y - goal.y).abs();
    int iDist = (toInsert.value.x - goal.x).abs() + (toInsert.value.y - goal.y).abs();
    return qDist - iDist;
  });
  queue.enqueue(Node(Point(1,1)));
  seen.add(Point(1,1));
  Node<Point>? found = null;
  while(queue.length > 0 && found == null) {
    var currentNode = queue.dequeue();
    var newx = currentNode.value.x - 1;
    var newy = currentNode.value.y;
    if(newx > -1 && map[newx][newy]){
      var p = Point(newx,newy);
      if(p == goal){
        found = Node(p, currentNode);
        continue;
      }
      if(seen.add(p)) queue.enqueue(Node(p, currentNode));
    }
    newx += 2;
    if(newx < map.length && map[newx][newy]){
      var p = Point(newx,newy);
      if(p == goal){
        found = Node(p, currentNode);
        continue;
      }
      if(seen.add(p)) queue.enqueue(Node(p, currentNode));
    }
    newx -= 1;
    newy -= 1;
    if(newy > -1 && map[newx][newy]){
      var p = Point(newx,newy);
      if(p == goal){
        found = Node(p, currentNode);
        continue;
      }
      if(seen.add(p)) queue.enqueue(Node(p, currentNode));
    }
    newy += 2;
    if(newy < map[0].length && map[newx][newy]){
      var p = Point(newx,newy);
      if(p == goal){
        found = Node(p, currentNode);
        continue;
      }
      if(seen.add(p)) queue.enqueue(Node(p, currentNode));
    }
  }
  if(found == null) return -1;
  if(print){
    var strmap = stringMap(map);
    Node<Point>? curNode = found;
    while(curNode != null){
      strmap[curNode.value.x][curNode.value.y] = "0";
      curNode = curNode.parent;
    }
    printStringMap(strmap);
  }
  return found.length;
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