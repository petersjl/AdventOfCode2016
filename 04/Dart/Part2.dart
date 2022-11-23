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
  for(String line in parseInput() as List<String>){
    var roomValue = getValueOfRoomString(line);
    if (roomValue != 0){
      var name = decryptName(line);
      if (name == 'northpole object storage ') print('Northpole object storage is in room $roomValue');
    }
  }
}

String decryptName(String roomString){
  List<String> parts = roomString.split(new RegExp('-|\\[|\\]'));
  parts.removeLast(); // Remove the empty piece
  int roomValue = int.parse(parts.removeLast());
  String name = '';
  for (String code in parts){
    for (String char in code.characters){
      name += shiftLetter(char, roomValue);
    }
    name += ' ';
  }
  return name;
}

int aVal = 'a'.codeUnitAt(0);
int zVal = 'z'.codeUnitAt(0);
String shiftLetter(String letter, int amount){
  int val = letter.codeUnitAt(0);
  val += amount;
  while (val > zVal){
    val -= (zVal - aVal) + 1;
  }
  return String.fromCharCode(val);
}

int getValueOfRoomString(String roomString){
  List<String> parts = roomString.split(new RegExp('-|\\[|\\]'));
  parts.removeLast(); // Remove the empty piece
  String checksum = parts.removeLast();
  int roomValue = int.parse(parts.removeLast());
  return checksum == calculateCheckSum(parts) ? roomValue : 0;
}

String calculateCheckSum(List<String> roomCodes){
  Map map = {};
  for (String code in roomCodes){
    for (String char in code.characters){
      if (map.containsKey(char)) map[char] += 1;
      else map[char] = 1;
    }
  }
  List<Pair> pairs = [];
  for (String key in map.keys){
    pairs.add(new Pair(key, map[key]));
  }
  pairs.sort((a, b) {
    int valCompare = a.val.compareTo(b.val) * -1; // To make bigger vals first
    if (valCompare == 0) return a.char.compareTo(b.char);
    else return valCompare;
  });
  String checksum = '';
  for (int i = 0; i < 5; i++) checksum+= pairs[i].char;
  return checksum;
}

class Pair{
  String char;
  int val;

  Pair(this.char, this.val);
}