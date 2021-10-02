/*  
    Dennis Andersen - deand17 and 
    Nicolai Dinh Khang Truong - nitru16
    
    30 September 2021

    DM841 Heuristics and Constraint Programming

    University of Southern Denmark

    Assignment 1, problem 1 - Aquarium
    
    This file contains the Minizinc model for the problem.
    
    The problem description can be found at 
    
    https://github.com/alviano/lpcp-contest-2020/tree/master/problem-1
*/

%%%%% PARAMETERS
6..30: S;
1..100: B; % number of blocks

array[1..S] of int: COLUMN_CLUES;
array[1..S] of int: ROW_CLUES;

set of int: ROWS = 1..S;
set of int: COLUMNS = 1..S;
set of int: BLOCKS = 1..B;

array[ROWS,COLUMNS] of int: BLOCK_GRID;

%%%%% DECISION VARIABLES
array[ROWS,COLUMNS] of var 0..1: grid;

%%%%% CONSTRAINTS

% Constraint for satisfying column clues
constraint forall(j in COLUMNS)(
    sum(i in ROWS) (grid[i,j]) == COLUMN_CLUES[j]
);

% Constraint for satisfying the gravity criterion, that is, water "falls" 
% to the "bottom" of a block, or in other words, that we use the largest 
% column indices of each block first
constraint forall(block in BLOCKS)(
    forall(j in COLUMNS)(
        forall(i,k in ROWS where i < k)(
            if BLOCK_GRID[i,j] == block /\ BLOCK_GRID[k,j] == block
            then grid[i,j] <= grid[k,j]
            else true 
            endif
        )
    )
);

% Constraint for satisfying row clues
constraint forall(i in ROWS)(
    sum(j in COLUMNS) (grid[i,j]) == ROW_CLUES[i]
);

% Constraint for satisfying the beauty criterion, that is, for a given row i, 
% the water level of the block is the same across that row
constraint forall(block in BLOCKS)(
    forall(i in ROWS)(
        forall(j,k in COLUMNS where j < k)(
            if BLOCK_GRID[i,j] == block /\ BLOCK_GRID[i,k] == block
            then grid[i,j] == grid[i,k]
            else true 
            endif
        )
    )
);

%%%%% SOLVE MODEL

solve satisfy;

%%%%% FOR PRODUCING OUTPUT

output [ "" ++ if show(grid[i,j]) == "1" then "*" else "." endif ++
    if j == S then "\n" else "" endif |
    i in ROWS, j in COLUMNS
];
