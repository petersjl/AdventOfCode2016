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
  int totalUsed = 0;
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
      totalUsed += parseNoEnd(currentLine[2]) as int;
      index++;
    }
    mnodes.add(inList);
    ++x;
  }
  return [mnodes , totalUsed ~/ index];
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
  var parts = parseInput() as List;
  var nodes = parts[0] as List<List<MNode>>;
  var averageCutoff = (parts[1] * 3) ~/ 2;
  for(int colout = 0; colout < nodes[0].length; ++colout){
    var rowbuf = StringBuffer();
    for(int rowout = 0; rowout < nodes.length; ++rowout){
      MNode a = nodes[rowout][colout];
      if(a.size > averageCutoff){
        rowbuf.write('  |   ');
        continue;
      }
      if(a.used == 0){
        rowbuf.write('  _   ');
        continue;
      }
      rowbuf.write(pad(a.used.toString(), 2, true));
      rowbuf.write('/');
      rowbuf.write(pad(a.size.toString(), 2));
      rowbuf.write(' ');
    }
    print(rowbuf.toString());
  }
}

String pad(String s, int length, [bool start = false]){
  if(s.length >= length) return s;
  StringBuffer buf = StringBuffer();
  int amount = length - s.length;
  if(!start) buf.write(s);
  while(amount > 0){
    buf.write(" ");
    amount--;
  }
  if(start) buf.write(s);
  return buf.toString();
}