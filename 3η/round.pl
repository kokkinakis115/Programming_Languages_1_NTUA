%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Read from file
read_input(File, M, N, List) :-
    open(File, read, Stream),
    read_line(Stream, [M, N]),
    read_line(Stream, List).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

add_zeros(A, 0, A) :- !.
add_zeros(A, Times, C) :-
  append(A, [0], B),
  Op is Times - 1,
  add_zeros(B, Op, C).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New list
create_list([], Curr, Total, C_list, Answer, Curr) :-
  append(C_list, [Total], Answer).
create_list([Hd|Tl], Curr, Total, C_list, Answer, Index) :-
  (Hd =:= Curr -> Total_plus is Total + 1,
      create_list(Tl, Curr, Total_plus, C_list, Answer, Index)
    ;Times is Hd - Curr - 1,
    append(C_list, [Total], New_c_list),
    New_total is 1,
    add_zeros(New_c_list, Times, Lst),
    create_list(Tl, Hd, New_total, Lst, Answer, Index)
  ).

sum_and_max(N, [A], Dist, Dist, MaxIndex) :-
  Dist is N - A,
  MaxIndex = A,
  !.
sum_and_max(N, [Hd|Tl], Sum, Tak, MaxIndex) :-
  (Hd =\= 0 -> sum_and_max(N, Tl, TailSum, Max, _),
  Dist is N - Hd,
  Sum is Dist + TailSum,
  Tak is max(Dist, Max),
  MaxIndex = Hd
  ;sum_and_max(N, Tl, Sum, Tak, MaxIndex)
  ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Solutions
viable(NewSum, CurMaxDist) :-
  CurMaxDist =< NewSum - CurMaxDist + 1.
% viable(NewSum, CurMaxDist) :-
%   NewSum - CurMaxDist + 1 =< CurMaxDist.

move_index_restart(IndexMax, N, [], [Hd3|Tl3], NewIndexMax, NewArr2) :-
  (Hd3 =:= 0 -> Kappa is IndexMax + 1,
    move_index_restart(Kappa, N, [], Tl3, NewIndexMax, NewArr2)
    ;NewIndexMax = IndexMax,
    NewArr2 = []
  ).

move_indexmax(_, N, [], Arr3, NewIndexMax, NewArr2) :-
  move_index_restart(0, N, [], Arr3, NewIndexMax, NewArr2).

move_indexmax(IndexMax, N, [Hd1|Tl1], Arr3, NewIndexMax, NewArr2) :-
  (Hd1 =:= 0 -> Kappa is IndexMax + 1,
    move_indexmax(Kappa, N, Tl1, Arr3, NewIndexMax, NewArr2)
    ;NewIndexMax is IndexMax + 1,
    NewArr2 = Tl1
  ).

% check_index(_, IndexMax, _, [], [Hd3|_], 0, [Hd3]).
check_index(IndexMainPlus, IndexMax, N, Arr2, Arr3, NewIndexMax, NewArr2) :-
  (IndexMainPlus =\= IndexMax ->
    NewIndexMax = IndexMax,
    NewArr2 = Arr2
    ;once(move_indexmax(IndexMax, N, Arr2, Arr3, NewIndexMax, NewArr2))
  ).

check_min_sum(NewSum, IndexMainPlus, CurMaxDist, MinSum, _,  NewMinSum, NewMinCityIndex) :-
  viable(NewSum, CurMaxDist),
  MinSum > NewSum,
  NewMinSum = NewSum,
  NewMinCityIndex = IndexMainPlus.
check_min_sum(NewSum, IndexMainPlus, CurMaxDist, MinSum, MinCityIndex,  NewSum, NewMinCityIndex) :-
  viable(NewSum, CurMaxDist),
  MinSum =:= NewSum,
  NewMinCityIndex is min(IndexMainPlus, MinCityIndex).
check_min_sum(_, _, _, MinSum, MinCityIndex,  MinSum, MinCityIndex).


solutions(_, _, [], _, _, _, _, _, InitMinSum, InitMinCityIndex, InitMinSum, InitMinCityIndex).    %array1,2,3
solutions(N, K, [Hd|Tl], Arr2, Arr3,IndexMain, IndexMax, CurSum, InitMinSum, InitMinCityIndex, FinMinSUM, FinMinCityIndex) :-
  NewSum is CurSum + K - N*Hd,
  (IndexMain > IndexMax ->
    CurMaxDist is IndexMain - IndexMax
    ;CurMaxDist is N - IndexMax + IndexMain
  ),
  IndexMainPlus is IndexMain + 1,
  once(check_index(IndexMainPlus, IndexMax, N, Arr2, Arr3, NewIndexMax, NewArr2)),
  once(check_min_sum(NewSum, IndexMain,CurMaxDist, InitMinSum, InitMinCityIndex, NewMinSum, NewMinCityIndex)),
  append(Arr3, [Hd], List3),
  once(solutions(N, K, Tl, NewArr2, List3, IndexMainPlus, NewIndexMax, NewSum, NewMinSum, NewMinCityIndex, FinMinSUM, FinMinCityIndex)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cut
cut(A, -1, A) :- !.
cut([_|Tl], IndexMax, B) :-
  Counter is IndexMax - 1,
  cut(Tl, Counter, B).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main

round(File, FinMinSUM, FinMinCityIndex) :-
    read_input(File,N,K,Init_st),
    sort(0, @=<, Init_st, Sr_init),
    once(create_list(Sr_init, 0, 0, _, Result, Index)),
    Times is N - Index - 1,
    add_zeros(Result, Times, [HdAr1|TlAr1]),
    sum_and_max(N, Sr_init, SSum, MaxDist, MaxIndex), %tsekare an einai viable an dn einai arxikopoihsh sto 10.000
    (viable(SSum, MaxDist) -> Sum is SSum
      ;Sum is 10000
    ),
    cut([HdAr1|TlAr1], MaxIndex, Array2),
    once(check_index(1, MaxIndex, N, Array2, [HdAr1], NewIndexMax, NewArr2)),
    once(solutions(N, K, TlAr1, NewArr2, [HdAr1], 1, NewIndexMax, Sum, Sum, 0, FinMinSUM, FinMinCityIndex)).
