import 'dart:io';
import 'dart:convert';
import '../../DartUtils.dart';
import 'package:crypto/crypto.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Object input = File(filePath).readAsStringSync();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var salt = parseInput() as String;
  int index = -1;
  List<String> queue = List.generate(1000, (i) => generateStretchHash(salt + i.toString()));
  int count = 0;
  while(count < 64){
    index++;
    var hash = queue.removeAt(0);
    queue.add(generateStretchHash(salt + (index + 1000).toString()));
    var term = charRun(hash, 3);
    if(term != null){
      for(var s in queue){
        if(charRun(s, 5, term) != null){
          count++;
          break;
        }
      }
    }
  }
  print("The last has was found at index ${index}");
}

String generateStretchHash(String input){
  var hash = generateMd5(input);
  for(int i = 0; i < 2016; ++i){
    hash = generateMd5(hash);
  }
  return hash;
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String? charRun(String str, int count, [String term = ""]){
  int curRun = 0;
  String curChar = term;
  for(int i = 0; i < str.length; ++i){
    if(str[i] == curChar){
      curRun++;
      if(curRun == count) return curChar;
    }
    else{
      if(term == ""){
        curChar = str[i];
        curRun = 1;
      }
      else{
        curRun = 0;
      }
    }
  }
  return null;
}