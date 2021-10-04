:- use_module(library(random)).

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

my_flatten([], []).
my_flatten([H|T], Out) :-
    is_list(H),
    my_flatten(H, I),
    my_flatten(T, U),
    append(I, U, Out).
my_flatten([H|T], [H|Out]) :-
    \+ is_list(H),
    my_flatten(T, Out).

compress([], []).
compress([H|T], [H|Out]) :- compress(T, H, Out).

compress([], _, []).
compress([H|T], H, Out) :- compress(T, H, Out).
compress([H|T], L, [H|Out]) :-
    H \= L,
    compress(T, H, Out).

pack([], []).
pack([H|T], Out) :- pack(T, [H], Out).

pack([], Acc, [Acc]).
pack([H|T], [H|R], Out) :-
    pack(T, [H,H|R], Out).
pack([H|T], [X|R], [[X|R]|Out]) :-
    H \= X,
    pack(T, [H], Out).

encode([], []).
encode([H|T], Out) :- encode(T, H, 1, Out).

encode([], H, N, [[N, H]]).
encode([H|T], H, N, Out) :-
    O is N + 1,
    encode(T, H, O, Out).
encode([H|T], X, N, [[N, X]|Out]) :-
    H \= X,
    encode(T, H, 1, Out).

encode_modified([], []).
encode_modified([H|T], Out) :- encode_modified(T, H, 1, Out).

encode_modified([], H, 1, [H]).
encode_modified([], H, N, [[N, H]]) :-
    N > 1.
encode_modified([H|T], H, N, Out) :-
    O is N + 1,
    encode_modified(T, H, O, Out).
encode_modified([H|T], X, 1, [X|Out]) :-
    encode_modified(T, H, 1, Out).
encode_modified([H|T], X, N, [[N, X]|Out]) :-
    N > 1,
    encode_modified(T, H, 1, Out).

decode([], []).
decode([[0, _]|T], Out) :-
    decode(T, Out).
decode([[N, X]|T], [X|Out]) :-
    N > 0,
    O is N - 1,
    decode([[O, X]|T], Out).
decode([X|T], [X|Out]) :-
    \+ is_list(X),
    decode(T, Out).

encode_direct(In, Out) :-
    % encode_modified already uses a direct solution
    encode_modified(In, Out).

dupli([], []).
dupli([H|T], [H,H|Rest]) :- dupli(T, Rest).

dupli([], _, []).
dupli([H|T], N, Out) :-
    dupli_val(H, N, D),
    dupli(T, N, R),
    append(D, R, Out).

dupli_val(_, 0, []).
dupli_val(V, N, [V|Out]) :-
    N > 0,
    M is N - 1,
    dupli_val(V, M, Out).

drop(In, N, Out) :- drop(In, 1, N, Out).

drop([], _, _, []).
drop([_|T], N, N, Out) :-
    drop(T, 1, N, Out).
drop([H|T], I, N, [H|Out]) :-
    I < N,
    J is I + 1,
    drop(T, J, N, Out).

split(In, 0, [], In).
split([H|T], N, [H|Rest], L2) :-
    M is N - 1,
    split(T, M, Rest, L2).

slice([H|_], _, 1, [H]).
slice([H|T], 1, End, [H|Out]) :-
    End > 1,
    NewEnd is End - 1,
    slice(T, 1, NewEnd, Out).
slice([_|T], Start, End, Out) :-
    Start > 1,
    End > 1,
    NewStart is Start - 1,
    NewEnd is End - 1,
    slice(T, NewStart, NewEnd, Out).

rotate(In, N, Out) :-
    N >= 0,
    split(In, N, L1, L2),
    append(L2, L1, Out).
rotate(In, N, Out) :-
    N < 0,
    length(In, Len),
    PosN is Len + N,
    rotate(In, PosN, Out).

remove_at(H, [H|T], 1, T).
remove_at(X, [H|T], N, [H|Out]) :-
    N > 1,
    M is N - 1,
    remove_at(X, T, M, Out).

insert_at(H, T, 1, [H|T]).
insert_at(X, [H|T], N, [H|Out]) :-
    N > 1,
    M is N - 1,
    insert_at(X, T ,M, Out).

range(N, N, [N]).
range(N, M, [N|R]) :-
    N < M,
    NN is N + 1,
    range(NN, M, R).

rnd_select(_In, 0, []).
rnd_select(In, N, [X|Out]) :-
    is_list(In),
    N > 0,
    M is N - 1,
    length(In, Len),
    random_between(1, Len, Idx),
    remove_at(X, In, Idx, Rest),
    rnd_select(Rest, M, Out).
rnd_select(N, M, Out) :-
    integer(N),
    range(1, M, L),
    rnd_select(L, N, Out).

rnd_permu(In, Out) :-
    length(In, Len),
    rnd_select(In, Len, Out).


main :-
    my_last(d, [a, b, c, d]),
    my_almost_last(c, [a, b, c, d]),
    element_at(c, [a, b, c, d, e], 3),
    my_length(5, [a, b, c, d, e]),
    my_reverse([a, b, c, d, e], [e, d, c, b, a]),
    palindrome([x, a, m, a, x]),
    my_flatten([a, [b, [c, d], e]], [a, b, c, d, e]),
    compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [a, b, c, a, d, e]),
    pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],
        [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]),
    encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],
        [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]]),
    encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],
        [[4,a],b,[2,c],[2,a],d,[4,e]]),
    decode([[4, a], b, [2, c], [2, a], d, [4, e]],
        [a,a,a,a,b,c,c,a,a,d,e,e,e,e]),
    encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],
        [[4,a],b,[2,c],[2,a],d,[4,e]]),
    dupli([a,b,c,c,d], [a,a,b,b,c,c,c,c,d,d]),
    dupli([a,b,c],3, [a,a,a,b,b,b,c,c,c]),
    drop([a,b,c,d,e,f,g,h,i,k],3,[a,b,d,e,g,h,k]),
    split([a,b,c,d,e,f,g,h,i,k], 3, [a,b,c], [d,e,f,g,h,i,k]),
    slice([a,b,c,d,e,f,g,h,i,k], 3, 7, [c,d,e,f,g]),
    rotate([a,b,c,d,e,f,g,h], 3, [d,e,f,g,h,a,b,c]),
    rotate([a,b,c,d,e,f,g,h], -2, [g,h,a,b,c,d,e,f]),
    remove_at(b, [a,b,c,d], 2, [a,c,d]),
    insert_at(alfa, [a,b,c,d], 2, [a,alfa,b,c,d]),
    range(4, 9, [4,5,6,7,8,9]),
    L1 = [a,b,c,d,e,f,g,h],
    rnd_select(L1, 3, L2),
    length(L2, 3),
    is_set(L2),
    forall(member(X, L2), member(X, L1)),
    rnd_select(6, 49, L3),
    length(L3, 6),
    is_set(L3),
    forall(member(X, L3), (X > 0, X < 50)),
    rnd_permu([a,b,c,d,e,f], L4),
    length(L4, 6),
    is_set(L4),
    forall(member(X, L4), member(X, [a,b,c,d,e,f])).
