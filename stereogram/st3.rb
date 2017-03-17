
skip = 10
raster = File.open('alice-revel.txt')
ARGF.each_line do |line|
  l = false
  l2 = false
  line.each_with_index do |char, index|
    letter = if l2
               ' '
             else
               raster.getc
             end
    if l and index > skip
      if char == ' '
        s = 0
      elsif char == "\n" || char == EOF
        s = 0
        l = true
      elsif char >= '0' and char <= '9'
        s = '0' - char
      else
        s = -2
      end
    else
      s = 0
    end
    s = index - (s + skip)
    if s < 0
  end
end

=begin
    for (y = 0; !feof(stdin); y++) {
        l = 0;
        l2 = 0;
        if (rnd)
            shift = rand();
        for (x = 0; x < width; x++) {
            if (f != null) {
                if (!l2) {
                    letter = getc(f);
                    if (letter == '\n' || letter == eof)
                        letter = ' ', l2 = 1;
                } else
                    letter = ' ';
            } else
                letter = !digit ? rand() % 32 + 'a' : rand() % 10 + '0';
            if (!l && x > skip) {
                s = getc(stdin);
                if (s == ' ')
                    s = 0;
                else if (s == '\n' || s == eof)
                    s = 0, l = 1;
                else if (s >= '0' && s <= '9')
                    s = '0' - s;
                else
                    s = -2;
            } else
                s = 0;
            s += skip;
            s = x - s;
            if (s < 0)
                s = string == null ? letter : string[(x + shift) % strlen(string)];
            else
                s = data[s];
            data[x] = s;
            putc(s, stdout);
        }
        putc('\n', stdout);
        s = 'a';
        while (!l && s != eof && s != '\n')
            s = getc(stdin);
        s = 'a';
        if (f != null)
            while (!l2 && s != eof && s != '\n')
                s = getc(f);
    }
    return 0;
=end
