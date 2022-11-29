import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input2.txt');
  List<String> input = File(filePath).readAsStringSync().splitNewLine();
  List<Disk> disks = [];
  int i = 0;
  for(var line in input){
    i++;
    var parts = line.split(" ");
    disks.add(Disk(int.parse(parts[3]), int.parse(parts[11].substring(0, parts[11].length - 1)) + i));
  }
  return disks;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var disks = parseInput() as List<Disk>;
  int time = 0;
  while(true){
    bool found = true;
    for(Disk d in disks){
      if(d.position != 0) found = false;
      d.move();
    }
    if(found) break;
    time++;
  }
  print('We should release at time = $time');
}

class Disk{
  int position;
  int posCount;

  Disk(this.posCount, this.position){
    this.position = this.position % this.posCount;
  }

  void move([int dist = 1]){
    position = (position + dist) % posCount;
  }

  @override
  String toString(){
    return 'Disk($position,$posCount)';
  }
}