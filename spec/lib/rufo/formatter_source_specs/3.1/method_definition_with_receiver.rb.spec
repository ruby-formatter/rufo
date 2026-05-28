#~# ORIGINAL issue_331
#~# parens_in_def: :dynamic
class User
  def self.by_uid uid:
    joins(:authentications).where(authentications: { uid: }).first
  end
end

#~# EXPECTED
class User
  def self.by_uid uid:
    joins(:authentications).where(authentications: { uid: }).first
  end
end
