# oo.rb
#                           wookay.noh at gmail.com

require "#{File.dirname __FILE__}/oo_header.rb"
@@palabras = POSTPOSITIONS.join('|')

class Rule
  attr_accessor :ter, :preferences
  def initialize ter
    @ter = ter
    @preferences = []
  end
  def preferences_push pri, ter
    @preferences.push [pri, ter]
    text = []
    for a,b in @preferences
      text.push %Q(["#{a}", "#{b}"])
    end
    open(RULES_PREFERENCES, 'w') do |f|
      f.write %Q([#{text.join","}])
    end
  end
  def lang_ext
    case @ter 
    when /oo$/
      "./Oo #{@ter}"
    when /rb$/
      "ruby #{@ter}"
    when /gp$/
      "gp -q #{@ter}"
    when /m$/
      "rake -f #{File.dirname @ter}/Rakefile --silent #{@ter} ; #{@ter}.out"
    end 
  end
  def call pri
    if @ter and File.exists? @ter
      open(RULES_PRI, 'w') do |f|
        f.write %Q("#{pri}")
      end
      command = %Q[#{lang_ext} '#{pri}' 2> /dev/null]
      result = `#{command}`
    end
    if result and not result.empty?
      if result =~ /^\{(.*)\}$/
        Hash.send :eval, result
      else
        pris = pri.strip
        preferences_push pris, result if not pris.empty? and not KEYWORDS.include? pris
        result
      end
    else
      pri
    end
  end
end

class Hash
  def tablize cols
    ary = cols.map{|col| fetch(col).split(', ')}
    col_sizes = ary.map{|l|l.map{|e|e.size}.max}
    ary.transpose.map do |l|
      l.zip(col_sizes).map{|e, just| e.to_s.ljust just}.join(' | ')
    end.join"\n"
  end
  def to_oo
    r = ''
    each do |k,v|
      r.concat "#{k}#{k.supporting} #{v}\n"
    end
    r
  end
end

class String
  def supporting
    POSTPOSITION_SUPPORTING.split('|')[self =~ /[136780lmr]$/ ? 0 : 1]
  end
end

class Oo
  def initialize
    @hash = {}
    @rule = Rule.new nil
  end
  def value_in_rule pri
    return if not @rule.ter
    value = @rule.call pri
    value if value
  end
  def ooval obj
    if @hash.has_key? obj
      @hash[obj]
    else
      value = value_in_rule obj
      if value
        value
      elsif @hash.invert.has_key? obj
        @hash.invert[obj]
      else
        obj
      end
    end
  end
  def run_q pri, ter_q
    case ter_q
    when /#{KEYWORD_WHAT}/
      case pri
      when /#{KEYWORD_ARGUMENTS}/
        value = ooval @hash[KEYWORD_ARGUMENTS]
        print value==KEYWORD_ARGUMENTS ?
          @hash[KEYWORD_ARGUMENTS] : value
      else
        de = pri.match /(.*)#{POSTPOSITION_POSSESSIVE} (.*)/
        if de
          uno = de[1]
          value = ooval uno
          dos = de[2]
          if value.class.to_s=='Hash'
            matched = []
            value[KEYWORD_ORDER].each do |k|
              matched.push k if dos.split(/(#{POSTPOSITION_CONJUCTIVE}) /).include? k
            end
            if matched.size > 1
              value = value.tablize matched
            else
              value = value[dos]
            end
          end
          print value
        else
          value = ooval pri
          if value.class.to_s=='Hash'
            value = value[KEYWORD_ORDER].map{|k|"#{value[k]}#{k}"}.join' '
          end
          print value
        end
        puts if ter_q!=KEYWORD_WHAT.split('|').last
      end
    else
      value = ooval pri
      if value.class.to_s=='Hash'
        if value.select{|k,v|"#{v}#{k}"==ter_q.to_s}.empty?
          matched = []
          if ter_q.split(' ').any? {|x| value[KEYWORD_ORDER].include? x}
            value[KEYWORD_ORDER].each do |k|
              matched.push k if ter_q.split(' ').include? k
            end
          else
            value[KEYWORD_ORDER].each do |k|
              ter_q.split(' ').each do |t|
                matched.push k if t =~ /(.*)#{k}$/
              end
            end 
          end
          if matched.empty?
            value = value[KEYWORD_ORDER].map{|k|"#{value[k]}#{k}"}.join' '
            assert_equal ter_q, value
          else
            value = matched.map{|k|"#{value[k]}#{k}"}.join' '
            puts value
          end
        else
          value = ter_q
          assert_equal ter_q, value
        end
      else
        if KEYWORDS.include? value
          value = KEYWORD_NO
        end
        assert_equal ter_q, value
      end
    end
  end

  def run text, ioo=false
    ret = nil
    text.split("\n").each do |line|
      next if line.strip[0,1]=='#'
      case line
      when /"(.*)"(#{@@palabras}) (.*)/
        m = {}
        m[1] = $1
        m[2] = $2
        m[3] = $3
      when /(.*)(#{@@palabras}) (.*)/
        m = {}
        m[1] = $1
        m[2] = $2
        m[3] = $3
      end
      if m
        pri = m[1]
        ter = m[3]
        case pri
        when /#{KEYWORD_RULES}/
          @rule.ter = ter
          @hash[KEYWORD_RULES] = ter
          ret = ter
        else
          q = ter.match /(.*)(\?)$/
          if q
            run_q pri, q[1]
          else
            if line =~ /#{POSTPOSITION_ADJECTIVE}/ and not line =~ /#{POSTPOSITION_SUPPORTING}/
              run_q line, KEYWORD_WHAT.split('|').first
            else
              @rule.preferences_push pri, ter
              @hash[pri] = ter
              ret = ter
            end
          end
        end
      else
        if ioo
          case line
          when " "
            open(RULES_PREFERENCES, 'w') do |f|
              f.write ''
            end
            @rule.preferences = []
            @hash = {}
          when /#{KEYWORD_PATTERNS}/
            if @rule.preferences.size.zero?
              ret = KEYWORD_NO
            else
              ret = @rule.preferences.map{|a,b|"#{a}는 #{b}"}
            end
          else
            ret = ooval line
            if KEYWORDS.include? line
              if ret == line
                ret = KEYWORD_NO
              end
            end
          end
        else
          @rule.preferences = []
        end
      end
    end
    ret
  end
  def fun file
    run open(file).read if File.exists? file.to_s
  end
  def main file, *argv
    @hash[KEYWORD_ARGUMENTS] = argv.join' '
    fun file
  end
  def ioo
    @hash['help'] = 'Oo help'
    @hash['copyright'] = OO_COPYRIGHT
    @rule.preferences = []
    prompt = "Oo> "
    while input = readline(prompt, false)
      break if 'quit'==input
      if File.exists? input.strip
        input = "#{KEYWORD_RULES}#{@@palabras} #{input.strip}"
      end
      result = run input, true
      puts result if result
      HISTORY.push input
    end
  end
  def self.runtime argv
    case argv
    when []
      puts "Oo #{OO_VERSION}"
      require "readline"
      include Readline
      Oo.new.ioo
    when %w{--help}
      puts <<EOF
    Usage: Oo [--] [programfile] [arguments]
      --copyright     print the copyright
      --version       print the version
EOF
    when %w{--copyright}
      puts OO_COPYRIGHT
    when %w{--version}
      puts "Oo #{OO_VERSION}"
    else
      oo = Oo.new
      oo.main *argv
    end
  end
end

def assert_equal expected, got
  puts expected == got ?
    "#{PASSED}: #{expected}" :
    "#{ASSERTION_FAILED}\n#{EXPECTED}: #{expected}\n#{GOT}: #{got}"
end
