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
  int count = 0;
  List<String> input = parseInput();
  for(int i = 0; i < input.length;){
    var parts0 = input[i].split(new RegExp('\\s+'))..removeAt(0);
    var parts1 = input[i+1].split(new RegExp('\\s+'))..removeAt(0);
    var parts2 = input[i+2].split(new RegExp('\\s+'))..removeAt(0);
    var triangles = trianglesFromRows(parts0, parts1, parts2);
    if (checkTriangle(triangles[0])) count++;
    if (checkTriangle(triangles[1])) count++;
    if (checkTriangle(triangles[2])) count++;
    i += 3;
  }
  print('There are $count possible triangles');
}

bool checkTriangle(List<int> parts){
  // List<String> strParts = str.split(new RegExp('\\s+'))..removeAt(0);
  // List<int> parts = strParts.listMap<int>(((e) => int.parse(e)));
  return parts[0] < parts[1] + parts[2] && parts[1] < parts[0] + parts[2] && parts[2] < parts[0] + parts[1];
}

List<List<int>> trianglesFromRows(List<String> one, List<String> two, List<String> three){
  List<List<int>> triangles = [];
  triangles.add([int.parse(one[0]),int.parse(two[0]),int.parse(three[0])]);
  triangles.add([int.parse(one[1]),int.parse(two[1]),int.parse(three[1])]);
  triangles.add([int.parse(one[2]),int.parse(two[2]),int.parse(three[2])]);
  return triangles;
}