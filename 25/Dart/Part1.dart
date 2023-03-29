import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  List<Instruction> input = File(filePath).readAsStringSync().splitNewLine().listMap<Instruction>((String s) {
    var parts = s.split(' ');
    Method m = Method.cpy;
    switch(parts[0]){
      case 'cpy': m = Method.cpy; break;
       case 'inc': m = Method.inc; break;
       case 'dec': m = Method.dec; break;
       case 'jnz': m = Method.jnz; break;
       default: m = Method.out; break;
    }
    return Instruction(m, parts[1], parts.length == 3 ? parts[2] : null);
  });
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var instructions = parseInput() as List<Instruction>;
  int a = 0;
  while(true){
    var signal = generateSignalSet(a, instructions);
    if(checkSignal(signal)) break;
    a++;
  }
  print("Lowest int is $a");
}

List<int> generateSignalSet(int startVal, List<Instruction> instructions){
  var registers = {'a':startVal, 'b':0, 'c':0, 'd':0};
  var lineIndex = 0;
  List<int> out = [];
  while(lineIndex < instructions.length){
    var current = instructions[lineIndex];
    switch(current.method){
      case Method.cpy:
        if(current.arg2 == null) break;
        if(int.tryParse(current.arg2!) != null) break;
        var num = int.tryParse(current.arg1);
        registers[current.arg2!] = num != null ? num : registers[current.arg1]!;
        break;
      case Method.inc: 
        if(current.arg2 != null) break;
        registers.update(current.arg1, (value) => ++value); break;
      case Method.dec: 
        if(current.arg2 != null) break;
        registers.update(current.arg1, (value) => --value); break;
      case Method.jnz: 
        if(current.arg2 == null) break;
        var check = int.tryParse(current.arg1);
        var dist = int.tryParse(current.arg2!);
        if(check == null) check = registers[current.arg1]!;
        if(dist == null) dist = registers[current.arg2!]!;
        if(check != 0) {
          lineIndex += dist;
          continue;
        }
        break;
      case Method.out:
        out.add(registers[current.arg1]!);
        if(out.length == 50) return out;
        break;
    }
    lineIndex++;
  }
  return [];
}

bool checkSignal(List<int> signal){
  for(int i = 0; i < signal.length; i++){
    if(signal[i] != i % 2) return false;
  }
  return true;
}

class Instruction{
  Method method;
  String arg1;
  String? arg2;

  Instruction(this.method, this.arg1, this.arg2);
}

enum Method{
  cpy,
  inc,
  dec,
  jnz,
  out
}