my_last(H, [H]).
my_last(H, [_|R]) :- my_last(H, R).

my_almost_last(H, [H, _]).
my_almost_last(H, [_|R]) :- my_almost_last(H, R).

element_at(X, [X|_], 1).
element_at(X, [_|T], N) :-
    O is N - 1,
    element_at(X, T, O).

my_length(0, []).
my_length(N, [_|R]) :-
    my_length(O, R),
    N is O + 1.

my_reverse(In, Out) :-
    my_reverse(In, [], Out).

my_reverse([], Acc, Acc).
my_reverse([H|T], Acc, Out) :-
    my_reverse(T, [H|Acc], Out).

palindrome(L) :-
    my_reverse(L, Out),
    L = Out.

main :-
    my_last(d, [a, b, c, d]),
    my_almost_last(c, [a, b, c, d]),
    element_at(c, [a, b, c, d, e], 3),
    my_length(5, [a, b, c, d, e]),
    my_reverse([a, b, c, d, e], [e, d, c, b, a]),
    palindrome([x, a, m, a, x]).
