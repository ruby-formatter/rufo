# frozen_string_literal: true

desc "Run tasks on CI"
task ci: :spec do
  Rake::Task["rufo:check"].invoke("lib spec")
end
