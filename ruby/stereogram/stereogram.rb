#!/usr/bin/env ruby

require 'pp'
require_relative './integermodulo'

class Stereogram
  attr_accessor :text
  attr_accessor :clue
  attr_accessor :vpad, :hpad

  def initialize(image_data, text = nil, period = 10, vpad = 10, hpad = 10)
    @text, @period = text, period
    @vpad, @hpad = vpad, hpad
    init_map(image_data)
  end

  def init_map(image_data)
    @image_chars = []
    @map = nil
    image_data.each_line do |line|
      if @map
        next if line.match?(/^\s*$/)
        key, val = *line.split
        @map[key.bytes.first] = val.to_i
      elsif line.strip == ''
        @map = {}
      else
        @image_chars << line.chomp
      end
    end
    @image = diff(pad(@image_chars))
    @groups = groups(@image_chars)
  end

  def width
    @image_chars[0].size + @hpad * 2 # left and right margins
  end

  def height
    @image_chars.size + @vpad * 2 # top and bottom
  end

  def output(file)
    @image.zip(groups).each do |line, group|
      out = ''
      previous = 0
      pos = 0
      line.each do |current| # current offset
        diff = previous - current
        if diff.positive?
          diff.times do
            # Add letters
            filler = block_given? ? yield : group[pos - 1]
            group.insert(pos, filler)
          end
          out << group[pos]
          file << ($DEBUG ? 'v' : group[pos])
        elsif diff.negative?
          # Remove letters
          (-diff).times do
            group.delete_at(pos)
          end
          out << group[pos]
          file << ($DEBUG ? '^' : group[pos])
        else
          out << group[pos]
          file << ($DEBUG ? '.' : group[pos])
        end
        previous = current
        pos += 1
        pos = pos % group.size
      end
      file << "\n"
    end
  end

  private

  def pad(image)
    char = image[0][0]
    zero_row = char * width
    hpadstr = char * @hpad
    vpadarr = [zero_row] * @vpad
    vpadarr + image.map{|line| hpadstr + line + hpadstr } + vpadarr
  end

  def diff(image)
    image.map do |row|
      row.split(//).map do |c|
        depth(c.bytes.first)
      end
    end
  end

  def depth(byte)
    if @map
      raise RuntimeError, "Byte does not appear in map: #{byte}, #{@map.inspect}" unless @map[byte]
      @map[byte]
    else
      @image_chars.first.bytes.first - byte
    end
  end

  class ModuloArray < Array
    def [](index)
      super(index % size)
    end

    def insert(index, obj)
      super(index % size, obj)
    end

    def delete_at(index)
      super(index % size)
    end
  end

  def groups(image = @image)
    result = []
    pos = 0
    image.each do
      while pos < @text.size
        result << @text[pos, @period]
        pos += @period
      end
      pos = @period - result.last.size
      result.last << result.first[0, pos]
    end
    result.map{|r| ModuloArray.new(r.split(//)) }
  end
end

if $PROGRAM_NAME == __FILE__
  image = File.read(ARGV[0] || 'pyramid')
  # text = "the trees are out toget you and break your babies with their branches  "
  text = File.read(ARGV[1] || 'alice-revel.txt')
  text.gsub!(/[^\w\s]/, '')
  text.gsub!(/\s+/, ' ')
  text.downcase!
  s = Stereogram.new(image, text, 20)
  s.output($stdout)
  # clue = "CAN YOU FIND THE SECRET CLUE?"
  # clue_index = IntegerModulo.new(clue.size)
  # s.output($stdout) do
  #   val = clue[clue_index]
  #   clue_index += 1
  #   val.chr
  # end
end
