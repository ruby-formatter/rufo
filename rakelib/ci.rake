desc "Run tasks on CI"
task :ci => :spec do
  Rake::Task["rubocop"].invoke
  Rake::Task["rufo:check"].invoke("lib spec")
end
