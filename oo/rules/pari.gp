read("rules/oo_header.rb")
ary = eval(read(RULES_PREFERENCES))
pri = read(RULES_PRI)
if(0==ary, \
  print1(pri) ; quit, \
0);
xa = apply(a->a[1], ary)
ya = apply(a->a[2], ary)
pol = x->polinterpolate(xa,ya,x)
print1(if(pri==KEYWORD_FUNCTION, pol(x), \
       if(pri==KEYWORD_INVERSE_FUNCTION, polinterpolate(ya,xa,x), \
       if(pri==KEYWORD_CODE, concat(concat("(x -> ", pol(x)), concat(")(", concat(xa[1], ")"))), \
                        pol(eval(pri))))))
quit
