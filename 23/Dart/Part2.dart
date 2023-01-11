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
       default: m = Method.tgl;
    }
    return Instruction(m, parts[1], parts.length == 3 ? parts[2] : null);
  });
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var instructions = parseInput() as List<Instruction>;
  var registers = {'a':12, 'b':0, 'c':0, 'd':0};
  var lineIndex = 0;
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
        // check for multiply loop
        if(lineIndex + 4 <= instructions.length &&
           lineIndex - 1 >= 0 &&
           instructions[lineIndex - 1].method == Method.cpy &&
           instructions[lineIndex + 1].method == Method.dec &&
           instructions[lineIndex + 2].method == Method.jnz &&
           instructions[lineIndex + 3].method == Method.dec &&
           instructions[lineIndex + 4].method == Method.jnz){
          var op1 = int.tryParse(instructions[lineIndex - 1].arg1) ?? registers[instructions[lineIndex - 1].arg1]; // Can be number or register
          var op2 = instructions[lineIndex + 3].arg1;
          var dest = instructions[lineIndex].arg1;
          var hold = instructions[lineIndex + 1].arg1;
          registers[dest] = registers[dest]! + op1! * registers[op2]!;
          registers[hold] = 0;
          registers[op2] = 0;
          lineIndex += 4;
        }
        else registers.update(current.arg1, (value) => ++value); break;
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
      case Method.tgl:
        if(current.arg2 != null) break;
        var dist = int.tryParse(current.arg1);
        if(dist == null) dist = registers[current.arg1]!;
        int modind = lineIndex + dist;
        if(modind >= instructions.length || modind < 0) break;
        Instruction modins = instructions[modind];
        switch(modins.method){
          case Method.cpy: modins.method = Method.jnz; break;
          case Method.inc: modins.method = Method.dec; break;
          case Method.dec: modins.method = Method.inc; break;
          case Method.jnz: modins.method = Method.cpy; break;
          case Method.tgl: modins.method = Method.inc; break;
        }
        break;
    }
    lineIndex++;
  }
  print('a ends with value ${registers["a"]}');
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
  tgl
}