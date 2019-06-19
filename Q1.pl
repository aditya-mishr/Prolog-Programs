
mem(X, [X | _]).
mem(X, [_ | T]) :- mem(X,T).



del(Z, [Z | Y], Y).
del(Z, [X | Y], [X | Y1]) :- del(Z, Y, Y1).



:- op(520,xfx, <).
:- op(500,xfy, >).
:- op(480,yfx, +).
:- op(460,yfx, ^).
:- op(440, fy, -).


semantictab(X) :-  T = b_tree(_, _, [X],_),solve(T),ptree(T,O,C),nl,((O>0)->write("...Consistent...");write("...Inconsistent...")),nl,((C<1)->write("....Valid....");write("")),!.


solve(b_tree(closed, empty, L,empty)) :- closepath(L),!.
solve(b_tree(open, empty, L,empty)) :-checkinglit(L),!.
solve(b_tree(Left, empty, L,L2)) :-andrule(L,L1,L2),Left = b_tree(_,_,L1,_),solve(Left),!.
solve(b_tree(Left, Right, L,L3)) :-orrule(L,L1,L2,L3),Left = b_tree(_,_,L1,_),Right = b_tree(_,_,L2,_),solve(Left),solve(Right),!.




closepath(L) :-mem(F,L), mem( - F, L).



checkinglit([]).
checkinglit([F | T]) :- literal(F),checkinglit(T),!.




literal(F) :- atom(F).
literal( - F) :- atom(F).

andrule(L, [A1 | L1],5) :- A =  - (- A1),mem(A,L),del(A,L, L1).
andrule(L, [A1, A2 | L1],A4) :-andformula(A,A1,A2,A4),mem(A,L),del(A,L, L1).


orrule(L, [B1 | L1], [B2 | L1],B3) :-orformula(B,B1,B2,B3),mem(B,L),del(B,L, L1).


andformula( A1^A2 , A1, A2,1).
andformula( - (A1 > A2), A1, - A2,7).
andformula( - (A1 +  A2),  - A1,  - A2,4).

orformula( A1 < A2 , A1 ^ A2 , -A2 ^ -A1,8).
orformula(A1 + A2, A1, A2,3).
orformula( A1 > A2, - A1, A2,6).
orformula( - (A1^A2), - A1, - A2,2).
orformula( -(A1 < A2) , -A1 ^ A2,-A2 ^ A1,9).



plist([F]) :- write(F).
plist([F | Tail]) :-write(F),write(","),plist(Tail).

pnum(empty):- !.
pnum(X):- write(".....................Applied Rule : "),write(X),!.


ptree(empty,0,0).
ptree(closed,0,1) :-write("...............ClosedPath"),!.
ptree(open,1,0) :-write("................OpenPath"),!.
ptree(b_tree(Left, Right, List,Rule),O,C) :-nl,plist(List),pnum(Rule),ptree(Left,O1,C1),ptree(Right,O2,C2),O is O1+O2,C is C1+C2,!.



