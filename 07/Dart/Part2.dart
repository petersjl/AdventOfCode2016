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
  List<String> abas = [];
  List<String> babs = [];
  for (int i = 0; i < parts.length; ++i){
    var part = parts[i];
    var pieces = checkForABA(part);
    (i % 2 == 0 ? abas : babs).addAll(pieces);
  }
  for (String aba in abas){
    if (checkForOppositeInList(aba, babs)) return 1;
  }
  return 0;
}

bool checkForOppositeInList(String aba, List<String> babs){
  for (String bab in babs){
    if (aba[0] == bab[1] && bab[0] == aba[1]) return true;
  }
  return false;
}

List<String> checkForABA(String section){
  int i = 0;
  List<String> abas = [];
  while (i < section.length - 2){
    if (section[i] == section[i+2] && section[i] != section[i+1]) abas.add(section[i] + section[i+1]);
    ++i;
  }
  return abas;
}