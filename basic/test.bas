REM test.bas
REM                           wookay.noh at gmail.com
REM                           http://wookay.egloos.com

 10 F = 100
 20 Y = 200
 30 N = 300
 40 T = 400
 50 R = T
 60 GOTO T

REM F
100 IF A=B THEN GOTO Y
110 GOTO N

REM Yes
200 PRINT "passed: " ; A
210 R=R+30: GOTO R

REM No
300 PRINT "Assertion failed"
310 PRINT "Expected: " ; A
320 PRINT "Got: " ; B
330 R=R+30: GOTO R

REM Tests
400 A = 1
410 B = 1
420 GOTO F
430 A = 3
440 B = 1+2
450 GOTO F
460 A = 7
470 B = 1+2*3
480 GOTO F
490 END
