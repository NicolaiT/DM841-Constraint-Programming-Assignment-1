int: s;
set of int: column = 1..s;
set of int: row = 1..s;

array[column] of int: column_clues;
array[row] of int: row_clues;
array[row, column] of var 0..1: answer;
array[row, column] of int: tanks; 

% Each row must be equal to the row clues
constraint forall(i in row) (
                              sum(j in column)(answer[i,j] == 1) == row_clues[i]);

% Each column must be equal to the column clues                              
constraint forall(j in column) (
                              sum(i in row)(answer[i,j] == 1) == column_clues[j]);

% Do the opposite just to help the solver       
constraint forall(i in row) (
                              sum(j in column)(answer[i,j] == 0) == abs(row_clues[i] - s));

constraint forall(j in column) (
                              sum(i in row)(answer[i,j] == 0) == abs(column_clues[j] - s));


% If there is no water underneath a filled block, then fill the water below as well only if it is in the same aquarium
constraint forall(i_a, i_b in row, j in column where i_b < i_a) (answer[i_a, j] < answer[i_b,j] /\ tanks[i_a, j] == tanks[i_b,j] -> answer[i_a, j] = 1 );

% Same goes for the water to the right
constraint forall(i in row, j_left, j_middle in column where j_left < j_middle) (
                              answer[i,j_left] < answer[i,j_middle] /\ tanks[i, j_left] == tanks[i, j_middle] -> answer[i,j_left] = 1);
% And to the left
constraint forall(i in row, j_middle, j_right in column where j_middle < j_right) ( 
                              answer[i,j_right] < answer[i,j_middle] /\ tanks[i, j_right] == tanks[i, j_middle] -> answer[i,j_right] = 1);

solve satisfy;

output[if fix(answer[i,j] == 1) then "*" else "." endif ++ if j == s then "\n" else "" endif  | i in row, j in column]