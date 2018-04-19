% ====================================================================
% Written by Jia Shun Low (Student Number: 743436).
% Department login ID: jlow3@student.unimelb.edu.au
% This program supplies a predicate and many helper predicates that
% holds true when a specific type of maths puzzle is solved. The
% rules of the math puzzle are defined as follows:

% 1. Each row and each column contains no repeated digits.
% 2. All squares on the diagonal line fom upper left to lower right
%    contain the same value
% 3. The heading of each row and column holds either the product or
%    sum of all the digits in that row or column.

% The puzzle will be supplied in the from of proper list of proper
% lists where each entry in that proper list of proper lists
% represents a row in the puzzle.
%
% Logic Programming is FUN!
% ====================================================================

% Load the SWI Prolog's Constraint Logic Programming Over
% Finite Domains Library, to make life easier.
:- ensure_loaded(library(clpfd)).


% The puzzle_solution predicate contains all the predicates that
% describe a solved puzzle.
puzzle_solution(Puzzle) :-
    % This predicate used to obtain the puzzle without the first row,
    % which we will call Rows since they are the relevant rows of
    % our puzzle.
    get_tail(Puzzle,Rows),

    % This predicate used to obtain the answer grid only.
    % maplist predicate is found in Prolog's built in library.
    maplist(get_tail,Rows,AnswerGrid),

    % This predicate binds all values of answer grid to 1 to 9 only.
    append(AnswerGrid,Vs), Vs ins 1..9,

    % We also require that every row and column in the answer grid
    % has a unique digit 1..9
    % we use the all_distinct predicate from the clpfd library.
    % We chose all_distinct over all_different because all_distinct
    % has stronger propogation.
    maplist(all_distinct, AnswerGrid),
    transpose(AnswerGrid, TransposedAnswerGrid),
    maplist(all_distinct, TransposedAnswerGrid),


    % The following predicates unifies the diagonal of the answer grid.
    get_diag(AnswerGrid,Diag),
    unify_list(Diag),

    % Predicate that checks that every row to see if the first element
    % is the sum or product of the remaining elements in that row.
    maplist(valid_list,Rows),

    % To get columns, we first transpose the whole puzzle...
    transpose(Puzzle,TransposedPuzzle),
    % ...then, we take away the first row of our new transposed puzzle.
    % this results in all our relevant columns arranged as rows now.
    % Then, we can do whatever logic checks we need on this new set
    % of columns.
    get_tail(TransposedPuzzle,Columns),
    maplist(valid_list,Columns),

    % Sometimes our program outputs the list of all the constraints
    % as the answer rather than the actual solved puzzle. The next
    % two predicates will ground all the variables in our puzzle,
    % so the final answer is in the output instead of a list of
    % constraints.
    append(AnswerGrid, Flat),
    label(Flat).


% This predicate holds if a list is unifiable. We use it in with
% get_diag to check if the diagonal of a puzzle is unifiable.
unify_list([]).
unify_list([_X]).
unify_list([H1,H2|T]) :-
    H1 = H2,
    unify_list([H2|T]).

% Predicate that gives us the diagonal of the answer grid.
get_diag( [ [H1|_T1] | GridTail], [H1|DiagTail]) :-
    maplist(get_tail, GridTail, NewGrid),
    get_diag(NewGrid,DiagTail).
get_diag([X],X).

% This predicate holds if a list has the head as a sum or product
% of all the elements in a list.
valid_list([H|T]):-
    head_sum([H|T]);
    head_multiply([H|T]).

% Predicate holds if head is the sum of every tail element in a list.
head_sum([H|T]):-
    list_sum(T,H).

% Predicate that gives us the sum of all elements in a list.
list_sum([H|T],Sum):-
    list_sum(T,NewSum),
    NewSum#=Sum-H.
list_sum([X],X).

% Predicate that holds if head is the product of every tail element in a
% list.
head_multiply([H|T]):-
    list_multiply(T,H).

% Predicate that gives us the product of all elements in a list.
list_multiply([X],X).
list_multiply([X|Xs],Product):-
    list_multiply(Xs,NewProduct),
    Product #= NewProduct*X.

% Predicate that holds if T is the tail of list in argument. Makes code
% more readable in situations where we need to use the tail of a list,
% rather than using the regular list notation all over our code.
get_tail([_H|T],T).




















