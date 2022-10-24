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
  List<String?> password = List<String?>.generate(8, (index) => null);
  int index = 0;
  for (int i = 0; i < 8; i++){
    while (true){
      var md5 = generateMd5(input + index.toString());
      if (checkmd5(md5)){
        int passIndex = int.parse(md5[5]);
        if (passIndex < 8 && password[passIndex] == null){
          password[passIndex] = md5[6];
          print('Found letter ${md5[6]} for spot $passIndex at index $index\t: ${getPassString(password)}');
          index++;
          break; 
        }
      }
      index++;
    }
  }
  return getPassString(password);
}

String getPassString(List<String?> pass){
  var password = '';
  for(String? s in pass){
    password += s ?? '_';
  }
  return password;
}

bool checkmd5(String guess){
  for (int i = 0; i < 5; i++){
    if (guess[i] != '0') return false;
  }
  var intCheck = int.tryParse(guess[5]);
  return intCheck != null;
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}