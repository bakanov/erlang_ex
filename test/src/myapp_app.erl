-module(myapp_app).
-export([flat/1,flat1/2]).
-include_lib("proper/include/proper.hrl"). %%important BEFORE eunit
-include_lib("eunit/include/eunit.hrl").

flat(List) when is_list(List) ->
	lists:reverse(flat1(List, [])).
	
prop_t2b_b2t() -> %%important to start with 'prop_'
	?FORALL(T, term(), 
		T =:= binary_to_term(term_to_binary({T}))).
		
proper_test_() ->
	{timeout, 300, ?assertEqual(
		[],
		proper:module(?MODULE, [{to_file, user},
					{numtests, 100}]))}.
					
prop_delete() ->
    ?FORALL({X,L}, {integer(),list(integer())},
            not lists:member(X, lists:delete(X, L))).
	    
prop_flat() ->
    ?FORALL({L}, {list(list())},
            not lists:any(fun is_list/1, flat(L))).
	
dummy() ->
	throw(badarg).

flat1([], Acc) ->
	Acc;	
flat1([H|T], Acc) when is_list(H) ->
	flat1(T, flat1(H,[]) ++ Acc);
flat1([H|T], Acc) ->
	flat1(T, [H|Acc]).
	
first_test() ->
	?assertEqual(flat([1]), [1]),
	%%?assertError(badarg, flat(7)),
	?assertError(function_clause, flat(7)),
	%%?assertError(badarg, dummy()),
	?assert(is_list(flat([1,[2,3]]))).
