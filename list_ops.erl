-module(list_ops).
-export([change/1,change1/2]).
-export([find/2,find1/3]).
-export([del/2,del1/4]).
-export([divide/2,divide1/3]).

%%better to crash, than to write error string
%%so better to delete 'when'

find(List, K) when ((K >= 1) and (K =< length(List))) ->
	find1(List, 1, K);
find(_List, _K) ->
	error.

find1([H|_T], _N, _N) ->
	H;	
find1([_H|Tail], N, K) ->
	find1(Tail,N+1,K).
	
del(List, K) when ((K >= 1) and (K =< length(List))) ->
	del1(List, 1, K, []);
del(_List, _K) ->
	error.

del1([_H|T], _N, _N, Acc) ->
	lists:reverse(Acc) ++ T;		
del1([H|T], N, K, Acc) ->
	del1(T, N+1, K, [H|Acc]).
	
divide(List, Len1) when ((Len1 >= 0) and (Len1 =< length(List))) ->
	divide1(List, Len1, []);
divide(_List, _K) ->
	error.

%%better to accomulate list from and, because ++ is a bad operation
divide1(List, K, Acc) when (length(Acc) =:= K)->
	[lists:reverse(Acc), List];	
divide1([H|T], K, Acc) ->
	divide1(T, K, [H|Acc]).

change(List) ->
	change1(List, []).

change1([], Acc) ->
	Acc;
change1(List, Acc) ->
	N = random:uniform(length(List)),
	change1(del(List, N), [find(List, N) | Acc]). %%++ is a bad operation