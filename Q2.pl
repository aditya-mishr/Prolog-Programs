
count([],0).
count([_|T],X):-count(T,X1),X is X1+1.


resrefutation(X,Y,Z):-refutation((X^(-Y)),Z),count(Z,L),nl,((L>0)->write("Not Consequence");write("Consequence")).




mem(X, [X | _]).
mem(X, [_ | T]) :- mem(X,T).


del(Z, [Z | Y], Y).
del(Z, [X | Y], [X | Y1]) :- del(Z, Y, Y1).




:- op(520,xfx, <).
:- op(500,xfy, >).
:- op(480,yfx, +).
:- op(460,yfx, ^).
:- op(440, fy, -).




refutation(F,Z) :-  T = [F],solve(T,X),duplicate(X,Y),!,write(Y),finaltest(Y,Y,Z),!.



solve(L,L) :-literals(L),!.
solve(L,X) :-andrule(L,L1),solve(L1,X),!.
solve(L,X) :-orrule(L,L1),solve(L1,X),!.

duplicate([H],[H]).
duplicate([H|T],Y):-duplicate(T,X),(mem(H,X)->append([],X,Y);append([H],X,Y)),!.



finaltest([],X,X).
finaltest([H|T],Y,Z2):-mem(H,Y),mem(-H,Y),del(H,Y,Z),del(-H,Z,Z1),finaltest(T,Z1,Z2).
finaltest([_|T],Y,Z1):-finaltest(T,Y,Z1).



literals([]).
literals([F | Tail]) :- literal(F),literals(Tail).




literal(F) :- atom(F).
literal( - F) :- atom(F).


andrule(L, [A1, A2 | Ltemp]) :-andformula(A,A1,A2),mem(A,L),del(A,L, Ltemp).
andrule(L, [A1 | Ltemp]) :- A =  - - A1,mem(A,L),del(A,L, Ltemp).

orrule(L, [B1, B2 | Ltemp]) :-orformula(B,B1,B2),mem(B,L),del(B,L, Ltemp).

andformula( A1^A2 , A1, A2).
andformula( - (A1 > A2), A1, - A2).
andformula( - (A1 +  A2),  - A1,  - A2).

orformula( A1 < A2 , A1 ^ A2 , -A2 ^ -A1).
orformula(A1 + A2, A1, A2).
orformula( A1 > A2, - A1, A2).
orformula( - (A1^A2), - A1, - A2).
orformula( -(A1 < A2) , -A1 ^ A2,-A2 ^ A1).


