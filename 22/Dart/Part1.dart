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
  input.removeAt(0);
  input.removeAt(0);
  var splitInput = input.listMap<List<String>>((String line) => line.split(new RegExp('\\s+')));
  int x = 0;
  int index = 0;
  Function parseNoEnd = (String s) => int.parse(s.substring(0, s.length - 1));
  List<List<MNode>> mnodes = [];
  while(index < splitInput.length){
    List<MNode> inList = [];
    while(index < splitInput.length){
      var currentLine = splitInput[index];
      List<int> coords = currentLine[0].substring(16).split('-y').listMap<int>((String s) => int.parse(s));
      if(coords[0] != x)break;
      inList.add(MNode(
        coords[0], 
        coords[1], 
        parseNoEnd(currentLine[1]), 
        parseNoEnd(currentLine[2]), 
        parseNoEnd(currentLine[3]), 
        parseNoEnd(currentLine[4])));
      index++;
    }
    mnodes.add(inList);
    ++x;
  }
  return mnodes;
}

class MNode {
  int x;
  int y;
  int size;
  int used;
  int avail;
  int percent;

  MNode(this.x,this.y,this.size,this.used,this.avail,this.percent);
}

// The main method of the puzzle solve
void solvePuzzle(){
  var nodes = parseInput() as List<List<MNode>>;
  int count = 0;
  for(int rowout = 0; rowout < nodes.length; ++rowout){
    for(int colout = 0; colout < nodes[0].length; ++colout){
      MNode a = nodes[rowout][colout];
      if(a.used == 0) continue;
      for(int rowin = 0; rowin < nodes.length; ++rowin){
        for(int colin = 0; colin< nodes[0].length; ++colin){
          if(rowout == rowin && colout==colin) continue;
          if(nodes[rowin][colin].avail >= a.used) count++;
        }
      }
    }
  }
  print('There are $count viable pairs');
}