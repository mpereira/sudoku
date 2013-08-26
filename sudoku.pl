% Copyright 2013 Murilo Pereira <murilo@murilopereira.com>
%
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
%
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

:- use_module(library(clpfd)).

% TODO: documentation.
cell_in_sub_matrix(C, M, SMIMin, SMJMin, SMW, SMH) :-
  SMIMax is SMIMin + SMW - 1,
  SMJMax is SMJMin + SMH - 1,
  between(SMIMin, SMIMax, SMIIndex),
  between(SMJMin, SMJMax, SMJIndex),
  nth0(SMIIndex, M, R),
  nth0(SMJIndex, R, C).

% TODO: documentation.
sub_matrix(M, SMIMin, SMJMin, SMW, SMH, SM) :-
  bagof(C, cell_in_sub_matrix(C, M, SMIMin, SMJMin, SMW, SMH), SM),
  SMCellCount is SMW * SMH,
  length(SM, SMCellCount).

% disjoint_sub_matrices(Matrix, SubMatrixWidth, SubMatrixHeight, SubMatrices)
%   `Matrix` is a two-dimensional list. `SubMatrices` is a list of `Matrix`'s
%   disjoint sub-matrices of width `SubMatrixWidth` and height
%   `SubMatrixHeight`.
%
% Example usage:
% 1. Getting all disjoint 2x2 sub-matrices from a 4x4 matrix:
% disjoint_sub_matrices([[ 1,  2,  3,  4],
%                        [ 5,  6,  7,  8],
%                        [ 9, 10, 11, 12],
%                        [13, 14, 15, 16]],
%                       2,
%                       2,
%                       What).
% What = [[[1, 2],
%          [5, 6]], [[3, 4],
%                    [7, 8]], [[ 9, 10],
%                              [13, 14]], [[11, 12],
%                                          [15, 16]]]).
%
% 2. Getting all disjoint 4x2 sub-matrices from a 4x4 matrix:
% disjoint_sub_matrices([[ 1,  2,  3,  4],
%                        [ 5,  6,  7,  8],
%                        [ 9, 10, 11, 12],
%                        [13, 14, 15, 16]],
%                        4,
%                        2,
%                        What).
% What = [[[ 1,  2],
%          [ 5,  6],
%          [ 9, 10],
%          [13, 14]], [[ 3,  4],
%                      [ 7,  8],
%                      [11, 12],
%                      [15, 16]]]).
%
disjoint_sub_matrices(M, MW, MH, SMW, SMH, SMs) :-
  bagof(SM,
          BI^BJ^
          (BIMax is MW - SMW,
           BJMax is MH - SMH,
           between(0, BIMax, BI),
           between(0, BJMax, BJ),
           0 is BI mod SMW,
           0 is BJ mod SMH,
           sub_matrix(M, BI, BJ, SMW, SMH, SM)),
          SMs).

% TODO: documentation.
maplength(L, List) :- length(List, L).
mapins(Domain, Vars) :- ins(Vars, Domain).

% TODO: make output pretty.
write_sudoku([]).
write_sudoku([Row | Rows]) :-
  write(Row),
  nl,
  write_sudoku(Rows).

% TODO: entry predicate that only takes two arguments: `Rows` and `Solution`.
sudoku(Rows, Width, Height, BlockWidth, BlockHeight, CellConstraint, Rows) :-
  length(Rows, Height),
  maplist(maplength(Height), Rows),
  maplist(mapins(CellConstraint), Rows),
  maplist(all_distinct, Rows),
  transpose(Rows, Columns),
  maplist(all_distinct, Columns),
  disjoint_sub_matrices(Rows, Width, Height, BlockWidth, BlockHeight, Blocks),
  maplist(all_distinct, Blocks),
  maplist(label, Rows),
  write_sudoku(Rows).

% TODO: read puzzle from text file.
% TODO: make it runnable from the command line.
