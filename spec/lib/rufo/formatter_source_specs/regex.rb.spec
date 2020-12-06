#~# ORIGINAL

//

#~# EXPECTED
//

#~# ORIGINAL

//ix

#~# EXPECTED
//ix

#~# ORIGINAL

/foo/

#~# EXPECTED
/foo/

#~# ORIGINAL

/foo #{1 + 2} /

#~# EXPECTED
/foo #{1 + 2} /

#~# ORIGINAL

%r( foo )

#~# EXPECTED
%r( foo )

#~# ORIGINAL

def regexp
  %r{
    \b            #     word boundary
    ([\w\-.])     # $1: username; first letter
    @             #     at
    ([a-z\d\-.]+) # $2: domain except TLD
    \.            #     dot
    ([a-z]+)      # $3: TLD
    \b            #     word boundary
  }xi
end

#~# EXPECTED
def regexp
  %r{
    \b            #     word boundary
    ([\w\-.])     # $1: username; first letter
    @             #     at
    ([a-z\d\-.]+) # $2: domain except TLD
    \.            #     dot
    ([a-z]+)      # $3: TLD
    \b            #     word boundary
  }xi
end
