read_input(File, _, List) :-
    open(File, read, Stream),
    read_line(Stream, [_]),
    read_line(Stream, List).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

move([], [Hs|Ts], 'S', [Hs], Ts).
move([Hq|Tq], [], 'Q', Tq, [Hq]).
move([Hq|Tq], [Hs|Ts], 'Q', Tq, [Hq,Hs|Ts]).
move([Hq|Tq], [Hs|Ts], 'S', Qe, Ts) :-
  % listlast(Stack, Nstack, E),
  \+Hq = Hs,
  append([Hq|Tq],[Hs],Qe).



mysolve(Queue, [], _, _) :-
  msort(Queue, Queue).
mysolve(Queue, Stack, [Move|Moves], Len) :-
  move(Queue, Stack, Move, Nq,Ns),
  mysolve(Nq,Ns,Moves, Len).

solve(InitialList, Moves) :-
    length(Moves, Len),
    Len mod 2 =:= 0,
    once(mysolve(InitialList,[], Moves, Len)).

qssort(File, Answer):-
  read_input(File,_,List),
  once(solve(List,Final)),
  length(Final,L),
  (L =:= 0 -> Answer = "empty"
  ; atomics_to_string(Final,Answer)
  ).
