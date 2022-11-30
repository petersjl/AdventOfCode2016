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
  var items = parseInput() as List<String>;
  int diskSize = int.parse(items[0]);
  String data = items[1];
  while(data.length < diskSize) data = expandData(data);
  var check = generateChecksum(data.substring(0,diskSize));
  print('The checksum for this data is $check');
}

String expandData(String data){
  var newData = StringBuffer();
  for(int i = data.length - 1; i >= 0; --i)
    newData.write(data[i] == "1" ? "0" : "1");
  return data + "0" + newData.toString();
}

String generateChecksum(String data){
  var checksum = data;
  while(checksum.length % 2 == 0){
    var newCheck = StringBuffer();
    for(int i = 1; i < checksum.length; i += 2) 
      newCheck.write(checksum[i] == checksum[i-1] ? "1" : "0");
    checksum = newCheck.toString();
  }
  return checksum;
}