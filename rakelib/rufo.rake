desc "Alias for `rake rufo:run`"
task :rufo => ["rufo:run"]

namespace :rufo do
  require "rufo"

  def rufo_command(*switches, rake_args)
    files_or_dirs = rake_args[:files_or_dirs] || "."
    args = switches + files_or_dirs.split(" ")
    result = Rufo::Command.run_and_return(args)
    abort("Rufo failed with #{result}") unless result == 0
  end

  desc "Format Ruby code in current directory"
  task :run, [:files_or_dirs] do |_task, rake_args|
    rufo_command(rake_args)
  end

  desc "Check that no formatting changes are produced"
  task :check, [:files_or_dirs] do |_task, rake_args|
    rufo_command("--check", rake_args)
  end
end
