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
  var instructions = parseInput() as List<String>;
  var registers = {'a':0, 'b':0, 'c':1, 'd':0};
  var lineIndex = 0;
  while(lineIndex < instructions.length){
    var line = instructions[lineIndex].split(" ");
    switch(line[0]){
       case 'cpy': 
        var num = int.tryParse(line[1]);
        registers[line[2]] = num != null ? num : registers[line[1]]!;
        break;
       case 'inc': registers.update(line[1], (value) => ++value); break;
       case 'dec': registers.update(line[1], (value) => --value); break;
       case 'jnz': 
        var num = int.tryParse(line[1]);
        if(num == null){
          if(registers[line[1]]! != 0) {
            lineIndex += int.parse(line[2]);
            continue;
          }
        }
        else{
          if(num != 0){
            lineIndex += int.parse(line[2]);
            continue;
          }
        }       
        break;
       default: {
        print('Invalid instruction "${line[0]}" at line $lineIndex');
        exit(1);
       }
    }
    lineIndex++;
  }
  print('a ends with value ${registers["a"]}');
}