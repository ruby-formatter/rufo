#~# ORIGINAL inline class

class MyError; end

#~# EXPECTED

class MyError; end

#~# ORIGINAL empty class

class Dragon
 def name; "Trogdor!";    end
end

#~# EXPECTED

class Dragon
  def name
    "Trogdor!"
  end
end
