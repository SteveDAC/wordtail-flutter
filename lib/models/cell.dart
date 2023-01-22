import 'package:json_annotation/json_annotation.dart';

import 'cell_state.dart';

part 'cell.g.dart';

@JsonSerializable()
class Cell {
  Cell();

  CellState cellState = CellState.none;
  String letter = '';

  Cell copy() {
    final cell = Cell();
    cell.cellState = cellState;
    cell.letter = letter;
    return cell;
  }

  factory Cell.fromJson(Map<String, Object?> json) => _$CellFromJson(json);
  Map<String, dynamic> toJson() => _$CellToJson(this);
}
