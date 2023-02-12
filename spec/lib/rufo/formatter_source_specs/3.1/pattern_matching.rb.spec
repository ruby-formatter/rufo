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
