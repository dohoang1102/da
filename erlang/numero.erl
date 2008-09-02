-module(numero).
-author('wookay.noh@gmail.com').
-export([numero/0]).

assert_equal(Expected, Got) ->
  Expected = Got,
  io:format("passed: ~w~n", [Expected]).

numero() ->
  [Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten] =
    lists:seq(0,10),
   Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten,

  assert_equal(Six, One + Two + Three),
  assert_equal(Six, One * Two * Three),
  assert_equal(true, One + Two == Three),
  assert_equal(true, One < Two),
  assert_equal(3, One + Two),
  assert_equal(Six, 1 + 2 + 3),
  assert_equal(Six, 1 + 2 + Three).
