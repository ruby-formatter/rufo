require "zlib"
require 'yaml'
require "diff/lcs"
require "fileutils"

class RenderSpecs
  FILE_PATH = 'dist'
  SOURCE_SPECS = File.join FILE_PATH, 'spec/lib/rufo/formatter_source_specs'
  SPEC_FILES = [File.join(SOURCE_SPECS, '**.rb.spec'),
                File.join(SOURCE_SPECS, '2.3/**.rb.spec')]
  TEMP_OUTDIR = 'temp_examples'
  FINAL_OUTDIR = '_examples'
  CONFIGDIR = '_data'

  def settings_count
    settings.size
  end

  def num_of_settings
    2 ** settings_count
  end

  def nav_to_yml(examples)
    ({"main" => [{"title" => "Introduction",
                  "url" => "/pages/introduction"},
                 {"title" => "Examples",
                  "url" => "/examples/alias"},
                 {"title" => "Settings",
                  "url" => "/pages/settings"}],
      "examples" => [{"title" => "Spec Examples",
                      "children" => examples}]}).to_yaml
  end

  def write_nav(tests)
    headings = [{"title" => "Introduction", "url" => "/examples/introduction"}]
    examples = []
    tests.each do |test|
      filename = File.basename(test[:file_name])
      name = filename.gsub('.rb.spec', '')
      examples << {"title" => "#{name + test[:version]}",
                   "url" => "/examples/#{name.gsub('?', '_qu').gsub('__', 'u_')}"}
    end
    File.open(File.join(CONFIGDIR, 'navigation.yml'), 'w') do |f|
      f.write nav_to_yml(examples)
    end
  end

  def render(text, mode, code)
    out = ''
    code.strip!
    case mode
    when :original
      out += "### #{text}\n"
      out += ruby_marker
      out += comment(:given)
    when :default
      out += ruby_marker
      out += comment(:becomes) unless code == ""
    when :setting
      out += ruby_marker
      out += comment(:setting, text)
    end
    out += code + nl
    out + ruby_end_marker
  end

  def md_file(filename)
    File.join(TEMP_OUTDIR,
              File.basename(filename)
                  .gsub('.rb.spec', '.md')
                  .gsub('?.md', '_qu.md')
                  .gsub('__', 'u_'))
  end

  def with_md_file(name)
    File.open(md_file(name), 'w') { |wf| yield wf }
  end

  def front_matter(filename, version)
    name = filename.gsub('.rb.spec', '')
    <<~EFM
      ---
      title: \"#{(name + version).gsub('_', '\\\\\\\\_')}\"
      permalink: \"/examples/#{name.gsub('?', '_qu').gsub('__', 'u_')}/\"
      toc: true
      sidebar:
        nav: "examples"
      ---

    EFM
  end

  def load_diffs
    yml = ''
    File.open('diffs.gz') do |f|
      gz = Zlib::GzipReader.new(f)
      yml = gz.read
      gz.close
      @diffs_hash = YAML.load(yml)
    end
  end

  def test_locator_name(name, line)
    "#{name} #{line}"
  end

  def settings
    [
      # name, default, alternative
      [:parens_in_def, :yes, :dynamic],
      [:align_case_when, false, true],
      [:align_chained_calls, false, true],
      [:trailing_commas, true, false],
    ]
  end

  def fetch_options(count)
    options = {}
    settings_count.times do |y|
      options[settings[y][0]] =
        (count & (1 << y) == 0) ?
          settings[y][1] : settings[y][2]
    end
    options
  end

  def fetch_option(count)
    options = fetch_options(count)
    str = ''
    settings_count.times do |y|
      if options[settings[y][0]] == settings[y][2]
        str += '`' + settings[y][0].to_s + ' ' + settings[y][2].inspect + '`'
      end
    end
    str
  end

  def original?(line)
    if line =~ /^#~# ORIGINAL ?([\w\s]+)$/
      @name = $~[1].strip
      return true
    end
    @name = ''
    false
  end

  def expected?(line)
    line =~ /^#~# EXPECTED$/
  end

  def pending?(line)
    line =~ /^#~# PENDING$/
  end

  def test_options?(line)
    line =~ /^#~# (.+)$/
  end

  def comment(type, extra = '')
    txt = case type
          when :given   then "# GIVEN"
          when :becomes then "# BECOMES"
          when :setting then "# with setting"
          end
    return txt + " #{extra}" + nl unless extra.empty?
    txt + nl
  end

  def ruby_marker
    '```ruby' + nl
  end

  def ruby_end_marker
    '```' + nl
  end

  def nl
    "\n"
  end

  def set_version(dir)
    @version = (dir.include?("2.3")) ?
      :two_three_plus : :all
  end

  def version
    @version == :two_three_plus ? ' (v2.3 +)' : ''
  end

  def default_format(code)
    Rufo::Formatter.format(code)
  end

  def update_diffs_maybe(yml)
    old_yml = ''
    File.open('diffs.gz') do |f|
      gz = Zlib::GzipReader.new(f)
      old_yml = gz.read
      gz.close
    end

    if old_yml != yml
      Zlib::GzipWriter.open('diffs.gz') do |gz|
        gz.write yml
        gz.close
      end
    end
  end

  def create_temp_dir
    destroy_temp_dir if Dir.exist? TEMP_OUTDIR
    Dir.mkdir TEMP_OUTDIR
  end

  def destroy_temp_dir
    FileUtils.rm_rf TEMP_OUTDIR
  end

  def doc_dir(name, type)
    dir = (type == :final ? FINAL_OUTDIR : TEMP_OUTDIR)
    "#{dir}/#{name}"
  end

  def copy_changed_examples(tests)
    temp = []
    final = []
    with_doc_files(:temp) { |t| temp << File.basename(t) }
    return if temp.empty?
    with_doc_files(:final) { |f| final << File.basename(f) }
    temp.each do |t|
      tname = doc_dir t, :temp
      fname = doc_dir t, :final
      if final.include? t
        copy = false
        File.open(tname, "r") do |t|
          File.open(fname, "r") do |f|
            copy = (f.read != t.read)
          end
        end
        if copy
          FileUtils.cp(tname, fname)
        end
        final.delete t
      else
        FileUtils.cp(tname, fname)
      end
    end
    final.each do |f|
      FileUtils.rm doc_dir f, :final
    end
  end

  def test_name
    @name == '' ?
      "unnamed #{@test_count}" :
      @name
  end

  def with_spec_dirs(paths)
    paths.each { |p| yield p }
  end

  def with_doc_files(type = :final)
    dir = type == :final ? FINAL_OUTDIR : TEMP_OUTDIR
    Dir.glob("#{dir}/*.md") { |f| yield f }
  end

  def with_spec_files(dir)
    files = Dir.glob(dir)
    files.each { |f| yield f }
  end

  def with_spec_lines(f)
    File.foreach(f).with_index { |l, idx| yield l, idx }
  end

  def get_tests
    @test_count = 0
    tests = []

    with_spec_dirs SPEC_FILES do |dir|
      set_version dir
      with_spec_files dir do |file|
        file_tests = []
        current_test = {}
        filename = File.basename file
        with_spec_lines(file) do |line, idx|
          if original?(line)
            unless current_test == {}
              file_tests << current_test
              current_test = {}
            end
            @test_count += 1
            current_test[:name] = test_name
            current_test[:original] = ""
            current_test[:line] = idx + 1
          elsif expected?(line)
            current_test[:expected] = ""
          elsif pending?(line)
            current_test[:pending] = true
          elsif test_options?(line)
          elsif current_test[:expected]
            current_test[:expected] += line
          elsif current_test[:original]
            current_test[:original] += line
          end
        end
        file_tests << current_test
        tests << {file_name: filename,
                  version: version,
                  tests: file_tests}
      end
    end
    tests
  end

  def unique_expects(exps)
    exps.uniq { |x| x[:expected] }
  end

  def sort_uniques(tests)
    STDOUT.puts "sorting"
    sorted = []
    tests.each do |test|
      sorted_data = []
      test[:tests].each do |data|
        expected_ary = []
        default = default_format(data[:original])
        num_of_settings.times do |iteration|
          name = test_locator_name(test[:file_name], data[:line])
          if @diffs_hash[name]
            if @diffs_hash[name][iteration]
              diff = @diffs_hash[name][iteration]
              new_expected = Diff::LCS.patch!(default, diff)
              expected_ary << {:setting => iteration, :expected => new_expected}
            end
          end
        end
        sorted_data << data.merge({:unique_expects => unique_expects(expected_ary)})
      end
      sorted << {file_name: test[:file_name],
                 relative_path: test[:relative_path],
                 version: test[:version],
                 tests: sorted_data}
    end
    sorted
  end

  def build(tests)
    STDOUT.puts "generating html"
    create_temp_dir
    tests.each do |test|
      filename = File.basename(test[:file_name])
      with_md_file(test[:file_name]) do |wf|
        wf.puts front_matter(filename, test[:version])
        test[:tests].each do |test_data|
          default = default_format(test_data[:original])
          wf.puts render(test_data[:name], :original, test_data[:original])
          wf.puts render('(default)', :default, default)
          uniques = test_data[:unique_expects]
          if uniques
            uniques.each_with_index do |uq, idx|
              next if idx.zero?
              wf.puts render("#{fetch_option(uq[:setting])}", :setting, uq[:expected])
            end
          end
        end
      end
    end
    write_nav tests
    copy_changed_examples tests
    destroy_temp_dir
  end

  def generate_diffs
    STDOUT.puts "generating diffs"
    diffs_hash = {}
    test_files = get_tests
    test_files.each do |tests|
      name = tests[:file_name]
      tests[:tests].each do |test|
        line = test[:line]
        diffs_hash[test_locator_name(name, line)] = {}
        diff_count = 0
        default = default_format(test[:original])
        num_of_settings.times do |iteration|
          options = fetch_options(iteration)
          formatted = Rufo::Formatter.format(test[:original], options)
          diff = Diff::LCS.diff(default, formatted)
          diffs_hash[test_locator_name(name, line)][iteration] = diff
          diff_count += 1 unless diff.empty?
        end
        diffs_hash[test_locator_name(name, line)] = nil if diff_count == 0
      end
    end
    yml = YAML.dump diffs_hash
    update_diffs_maybe yml
  end
end

FileUtils.rm_rf 'dist'
ret = system("git clone .git --branch master --single-branch dist")
puts "ret = #{ret.inspect}"
raise "Error: cloning git master branch to dist/ failed! Aborting!" unless ret
require_relative "dist/lib/rufo"
rs = RenderSpecs.new
rs.generate_diffs
rs.load_diffs
rs.build(rs.sort_uniques(rs.get_tests))
