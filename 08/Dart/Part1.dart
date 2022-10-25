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
  Display display = new Display(6, 50);
  parseInstructions(display, input);
  print('Display shows:\n$display');
  print('Count of lights: ${display.countOn()}');
}

void parseInstructions(Display display, List<String> instructions){
  for(String line in instructions){
    var parts = line.split(' ');
    switch(parts[0]){
      case 'rect':
        var values = parts[1].split('x');
        drawRect(display, int.parse(values[1]), int.parse(values[0]));
        break;
      case 'rotate':
        int a = int.parse(parts[2].split('=')[1]);
        int b = int.parse(parts[4]);
        Function f = parts[1] == 'row' ? rotateRow : rotateCol;
        f(display, a, b);
        break;
    }
  }
}

void drawRect(Display d, int rows, int cols){
  for(int r = 0; r < rows; r++){
    for(int c = 0; c < cols; c++){
      d[r][c] = true;
    }
  }
}

void rotateRow(Display d, int row, int amount){
  List<bool> curRow = d.getRow(row);
  List<bool> newRow = [];
  for(int i = 0; i < curRow.length; i++){
    newRow.add(curRow[(i - amount) % curRow.length]);
  }
  d.setRow(row, newRow);
}

void rotateCol(Display d, int col, int amount){
  List<bool> curCol = d.getCol(col);
  List<bool> newCol = [];
  for(int i = 0; i < curCol.length; i++){
    newCol.add(curCol[(i - amount) % curCol.length]);
  }
  d.setCol(col, newCol);
}

class Display{
  late List<List<bool>> _board;
  int rows;
  int cols;

  Display(this.rows, this.cols){
    _board = List<List<bool>>.generate(this.rows, (index) => List<bool>.generate(this.cols, (i) => false));
  }

  operator [](int index) => _board[index];

  int countOn(){
    int count = 0;
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        if(_board[r][c]) ++count;
      }
    }
    return count;
  }

  List<bool> getRow(int index){
    if(index < 0 || index >= this.rows) return [];
    return [..._board[index]];
  }

  void setRow(int index, List<bool> list){
    if(index < 0 || index >= this.rows || list.length != this.cols) return;
    this._board[index] = list;
  }

  List<bool> getCol(int index){
    if(index < 0 || index >= this.cols) return [];
    List<bool> list = [];
    for(int i = 0; i < this.rows; i++){
      list.add(_board[i][index]);
    } 
    return list;
  }

  void setCol(int index, List<bool> list){
    if(index < 0 || index >= this.cols || list.length != this.rows) return;
    for(int i = 0; i < this.rows; i++) {
      _board[i][index] = list[i];
    }
  }

  @override
  String toString() {
    String str = '';
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        str += _board[r][c] ? '#' : '.';
      }
      str += '\n';
    }
    return str;
  }
}