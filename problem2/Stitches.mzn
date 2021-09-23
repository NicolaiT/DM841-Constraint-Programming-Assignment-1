5..20: S;
1..5: N;
1..50: B;
set of int: column = 1..S;
set of int: row = 1..S;
set of int: blocks = 1..B;

%array[column] of int: column_clues;
%array[row] of int: row_clues;
array[row, column] of var 0..1: answer;
array[row, column] of int: tanks = [|1,2,2,2,3|
1,1,2,3,3|
1,4,2,4,4|
4,4,4,4,4|
4,5,5,4,4|];
array[row, column] of var 0..1: horizontal;
array[row, column] of var 0..1: vertical;
array[blocks, blocks] of var 0..B: blockgrid;

predicate adjacentToNeighbor(int:row, int:column) =
if tanks[row, column] != tanks[row, column+1]
then
    horizontal[row, column] = 1
elseif tanks[row, column] != tanks[row+1, column]
then
    vertical[row, column] = 1
else 
    true
endif;




% Each row must be equal to the row clues
%constraint forall(i in row) (
%                              sum(j in column)(answer[i,j] == 1) == %row_clues[i]);

% Each column must be equal to the column clues                              
%constraint forall(j in column) (
%                              sum(i in row)(answer[i,j] == 1) == %column_clues[j]);
                          
constraint forall(i in row, j in column where i < S /\ j < S) ( 
                              adjacentToNeighbor(i, j));
                                                                    
constraint forall(i in row, j in column) (
  if horizontal[i,j] == 1 
  then answer[i,j] = 1 
  elseif vertical[i,j] == 1 
  then answer[i,j] = 1
  else
    true
  endif);



output[show(answer[i,j]) ++ if j == S then "\n" else "" endif  | i in row, j in column]