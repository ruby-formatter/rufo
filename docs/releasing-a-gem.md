# Releasing a gem

1. Ensure that the tests pass and everything is working!

2. Add missing release notes to `CHANGELOG.md`

3. Bump version in
  * `lib/rufo/version.rb`
  * `CHANGELOG.md`

4. Commit version bump via
  * `git commit -v "Version X.Y.Z"`

5. Release gem to RubyGems via
  * `rake release`

6. :tada:
