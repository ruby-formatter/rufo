#~# ORIGINAL retry
begin
rescue

retry
end

#~# EXPECTED
begin
rescue
  retry
end
