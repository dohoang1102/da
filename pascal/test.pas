{ test.pas
                           wookay.noh at gmail.com
                           http://wookay.egloos.com 
}

procedure assert_equal(expected, got :integer);
begin
  if (expected=got) then
    writeln('passed: ', expected)
  else
    begin
      writeln('Assertion failed');
      writeln('Expected: ', expected);
      writeln('Got: ', got);
    end
end;

begin
  assert_equal( 1 , 1   );
  assert_equal( 3 , 1+2 );
end.
