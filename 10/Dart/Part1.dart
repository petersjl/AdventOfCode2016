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
  Map<int, Bot> bots = {};
  Map<int, Output> outputs = {};
  for(String line in input){
    var parts = line.split(" ");
    if(parts[0] == 'value'){
      var bot = bots.get(int.parse(parts[5]));
      bot.takeChip(int.parse(parts[1]), false);
      continue;
    }
    else{
      var bot = bots.get(int.parse(parts[1]));
      bot.lowTarget = parts[5] == 'bot' ? bots.get(int.parse(parts[6])) : outputs.get(int.parse(parts[6]));
      bot.highTarget = parts[10] == 'bot' ? bots.get(int.parse(parts[11])) : outputs.get(int.parse(parts[11]));
    }
  }
  Bot? current = bots.whereFirst((key, value) => (value as Bot).count == 2);
  current?.giveChips();
}

// Set these to find the first bot to compare these values
class CheckFor{
  static int val1 = 61;
  static int val2 = 17;
}

class Holder{
  void takeChip(int code, [bool cascade = true]){}
}

class Bot implements Holder{
  int name;
  int? chip1;
  int? chip2;
  int get count => (chip1 == null ? 0 : 1) + (chip2 == null ? 0 : 1);

  Holder? lowTarget;
  Holder? highTarget;

  Bot(this.name);

  void takeChip(int code, [bool cascade = true]){
    if(chip1 == null) chip1 = code;
    else if(chip2 == null) {
      chip2 = code;
      if(cascade) giveChips();
    }
    else print('Bot $name dropped chip $code');
  }

  void giveChips(){
    if(count != 2) return;
    if(lowTarget == null || highTarget == null){
      print('Bot $name is missing a target');
      return;
    }
    if((chip1 == CheckFor.val1 && chip2 == CheckFor.val2) || (chip1 == CheckFor.val2 && chip2 == CheckFor.val1)){
      print('Bot $name compared $chip1 and $chip2');
    }
    if(chip1! < chip2!){
      lowTarget!.takeChip(chip1!);
      highTarget!.takeChip(chip2!);
    }
    else{
      lowTarget!.takeChip(chip2!);
      highTarget!.takeChip(chip1!);
    }
  }
}

class Output implements Holder{
  int id;
  List<int> chips;

  Output(this.id): chips = []{}

  void takeChip(int code, [bool cascade = true]){
    chips.add(code);
  }
}

extension MapOfBots on Map<int, Bot>{
  Bot get(int index){
    var thing = this[index];
    if(thing != null) return thing;
    this[index] = new Bot(index);
    return this[index]!;
  }
}

extension MapOfOutputs on Map<int, Output>{
  Output get(int index){
    var thing = this[index];
    if(thing != null) return thing;
    this[index] = new Output(index);
    return this[index]!;
  }
}