-module(flat).
-export([flat/1,flat1/2]).

flat(List) ->
	lists:reverse(flat1(List, [])).

flat1([], Acc) ->
	Acc;	
flat1([H|T], Acc) when is_list(H) ->
	flat1(T, flat1(H,[]) ++ Acc);
flat1([H|T], Acc) ->
	flat1(T, [H|Acc]).
	