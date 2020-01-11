#~# ORIGINAL
module StringExt
  refine String do
    def wrap(what)
      before, after = self.split("|", 2)
      "#{before}#{what}#{after}"
    end
  end
end

using StringExt

#~# EXPECTED
module StringExt
  refine String do
    def wrap(what)
      before, after = self.split("|", 2)
      "#{before}#{what}#{after}"
    end
  end
end

using StringExt
