-module(csv).
-export([parse/1, parse_str/1]).

parse(File) ->
	{ok, Binary} = file:read_file(File),
	Strings = binary:split(Binary, [list_to_binary("\n")], [global]),
	lists:map(fun parse_str/1, Strings).
	
parse_str(String) ->
	list_to_tuple(lists:map(fun binary_to_smth/1, binary:split(String, [list_to_binary(",")], [global]))).
	
binary_to_smth(<<"\"", Rest1/binary>>) ->
	[Text, _Quote] = binary:split(Rest1, [list_to_binary("\"")], [global]),
	Text;
binary_to_smth(Val) ->
	float_or_int(catch binary_to_integer(Val), Val).
	
float_or_int({'EXIT', _}, Val) ->
	list_to_float(binary_to_list(Val));
float_or_int(Int, _Val) ->
	Int.