-module(rle).
-export([rle_code/1, rle_code1/3]).
-export([rle_decode/1, rle_decode1/2]).
-export([tuple_into_list/1, tuple_into_list1/4, filter_monos_back/1, filter_monos/1]).


rle_code([H|T]) ->
	%%[element(1,X) || X <- rle_code1(T, [H], []), element(2,X) =:= 1].
	filter_monos(rle_code1(T, [H], [])).
	
rle_code1([], [H1|T1], Acc) ->
	lists:reverse([{H1, length([H1|T1])}|Acc]);	
rle_code1([H|T], [H1|T1], Acc) when H =:= H1 ->
	rle_code1(T, [H|[H1|T1]], Acc);
rle_code1([H|T], [H1|T1], Acc) ->
	rle_code1(T, [H], [{H1, length([H1|T1])}|Acc]).
	
filter_monos(List) ->
	filter_monos1(List, []).
	
filter_monos1([], Acc) ->
	lists:reverse(Acc);	
filter_monos1([{C, 1}|T], Acc) ->
	filter_monos1(T, [C|Acc]);
filter_monos1([H|T], Acc) ->
	filter_monos1(T, [H|Acc]).
	
rle_decode(List) ->
	rle_decode1(filter_monos_back(List), []).
	
rle_decode1([], Acc) ->
	lists:reverse(Acc);	
rle_decode1([H|T], Acc) when is_tuple(H) ->
	rle_decode1(T, tuple_into_list(H) ++ Acc).
	
tuple_into_list({C, N}) ->
	tuple_into_list1(C, 0, N, []).
	
tuple_into_list1(_C, K, N, Acc) when N =:= K ->
	Acc;	
tuple_into_list1(C, K, N, Acc) ->
	tuple_into_list1(C, K+1, N, [C|Acc]).
	
filter_monos_back(List) ->
	filter_monos_back1(List, []).
	
filter_monos_back1([], Acc) ->
	lists:reverse(Acc);	
filter_monos_back1([C|T], Acc) when not is_tuple(C) ->
	filter_monos_back1(T, [{C, 1}|Acc]);
filter_monos_back1([H|T], Acc) ->
	filter_monos_back1(T, [H|Acc]).
	