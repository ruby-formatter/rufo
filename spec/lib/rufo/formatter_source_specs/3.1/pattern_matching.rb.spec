#~# ORIGINAL pin various variables

case   a
  in [^ $gvar,   ^@ivar  ,  ^@@cvar]
   1
end

#~# EXPECTED
case a
in [^$gvar, ^@ivar, ^@@cvar]
  1
end

#~# ORIGINAL pin expression

case   a
  in ^ ( 1+2 )
   1
end

#~# EXPECTED
case a
in ^(1 + 2)
  1
end
