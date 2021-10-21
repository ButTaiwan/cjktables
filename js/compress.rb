fx = File.open('charsets.txt', 'w:utf-8')

Dir.glob('*.txt').each { |fn|
	next if fn =~ /charsets/
	
	f = File.open(fn, 'r:utf-8')
	cjk = '0' * 21000
	ext = []
	f.each { |s|
		s.chomp!
		next if s == ''
		next if s[0] == '#'
		
		c, u, x = s.split(/\t/)
		d = u.to_i(16)
		if (0x4E00..0x9FFF).include?(d)
			cjk[d - 0x4E00] = '1'
		else
			ext << "0x#{u}"
		end
	}
	f.close
	
	cx = []
	700.times { |i|
		cx << '0x' + cjk[i*30 ... (i+1)*30].reverse.to_i(2).to_s(16).upcase
	}
	
	fk = fn.gsub(/\.txt/, '')
	
	fx.puts "\t'#{fk}': {"
	fx.puts "\t\tmap: [" + cx.join(',') + '],'
	fx.puts "\t\text: [" + ext.join(',') + '] },'
}
fx.close