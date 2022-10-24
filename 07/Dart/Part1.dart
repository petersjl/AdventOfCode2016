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
  var input = parseInput() as List<String>;
  int count = 0;
  for (String line in input){
    count += checkLine(line);
  }
  print('There are $count valid ips');
}

int checkLine(String line){
  var parts = line.split(new RegExp('\\[|\\]'));
  bool valid = false;
  for (int i = 0; i < parts.length; ++i){
    var part = parts[i];
    if (i % 2 == 1 && checkForABBA(part)) return 0; // If in brackets it can't be true
    if (valid) continue; // If we already have one not in brackets then we don't care about this one
    valid = checkForABBA(part);
  }
  return valid ? 1 : 0;
}

bool checkForABBA(String section){
  int i = 0;
  while (i < section.length - 3){
    if (section[i] == section[i+3] && section[i+1] == section[i+2] && section[i] != section[i+1]) return true;
    ++i;
  }
  return false;
}