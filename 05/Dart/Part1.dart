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
  print('The password is ${generatePassword(parseInput() as String)}');
}

String generatePassword(String input){
  print('Generating password from key $input');
  String password = '';
  int index = 0;
  for (int i = 0; i < 8; i++){
    while (true){
      var md5 = generateMd5(input + index.toString());
      var guess = checkmd5(md5);
      if (guess != null){
        print('Found letter $guess at index $index');
        password += guess;
        index++;
        break; 
      }
      index++;
    }
  }
  return password;
}

String? checkmd5(String guess){
  for (int i = 0; i < 5; i++){
    if (guess[i] != '0') return null;
  }
  return guess[5];
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}