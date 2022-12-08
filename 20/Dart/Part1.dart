import 'dart:io';
import 'dart:math';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<Pair<int,int>>((String line) {
    var parts = line.split('-');
    return Pair<int,int>(int.parse(parts[0]), int.parse(parts[1]));
  });
  input.sort(((a, b) {
    return a.first.compareTo(b.first);
  }));
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var ranges = parseInput() as List<Pair<int,int>>;
  ranges = reduce(ranges);
  print('First unblocked IP is ${ranges[0].second + 1}');
}

List<Pair<int,int>> reduce(List<Pair<int,int>> ranges){
  List<Pair<int,int>> reduced = [];
  int curLow = ranges[0].first;
  int curHigh = ranges[0].second;
  for(int i = 1; i < ranges.length; ++i){
    var check = ranges[i];
    if(check.first <= curHigh + 1) curHigh = max(curHigh, check.second);
    else{
      reduced.add(Pair<int,int>(curLow, curHigh));
      curLow = check.first;
      curHigh = check.second;
    }
  }
  reduced.add(Pair<int,int>(curLow, curHigh));
  return reduced;
}