bla_min([_], [_]).
bla_min([_,H2|Tl], [Head1,Head2|Tail]) :-
    Head2 is min(Head1,H2),
    bla_min([H2|Tl], [Head2|Tail]).

bla_max([_], [_]).
bla_max([_,H2|Tl], [Head1,Head2|Tail]) :-
    Head2 is max(Head1,H2),
    bla_max([H2|Tl], [Head2|Tail]).

final(N,_,_,I,J,Maxdiff,Answer) :-
    I =:= N ; J =:= N,
    Answer is Maxdiff.
final(N,[HL|TL], [HR|TR],I,J,Maxdiff,Answer) :-
    (HR >= HL -> F is J-I,
        Maxd is max(Maxdiff,F),
        Xptou is J+1,
        final(N,[HL|TL],TR,I,Xptou,Maxd,Answer)
    ; Xlepa is I+1,
      final(N,TL,[HR|TR],Xlepa,J,Maxdiff,Answer)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -element - N
prepare(_, [], []).
prepare(N, [Hd|Tl], [Head|Tail]) :-
        Head is -Hd-N,
        prepare(N,Tl, Tail).

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

sums(L, S) :- sumrunner(L, S, 0).
sumrunner([], [], _).
sumrunner([A|B], [C|D], TOTAL) :- C is TOTAL + A, sumrunner(B, D, C).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main
longest(File, Answer) :-
    read_input(File,M,N,L),
    once(prepare(N, L, Lst)),
    sums(Lst, Arr),
    nth0(M, [0|Arr], S),
    once(bla_min([0|Arr], [0|Lmin])),
    reverse([0|Arr], Rlist),
    once(bla_max(Rlist, [S|R])),
    reverse([S|R], Rmax),
    F is M+1,
    final(F,[0|Lmin], Rmax,0,0,-1, Answer).
