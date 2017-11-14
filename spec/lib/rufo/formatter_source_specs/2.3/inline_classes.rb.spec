#~# ORIGINAL multi_inline_definitions

class A end; class B end

#~# EXPECTED

class A end
class B end

#~# ORIGINAL multi_inline_definitions_with_comment

class A end; class B end; class C end # comment

#~# EXPECTED

class A end
class B end
class C end # comment
