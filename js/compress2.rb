fx = File.open('charsets2.txt', 'w:utf-8')

max = 20994
zp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
fmap = {'big5-1' => 'Big5-1', 'big5-2' => 'Big5-2', 'edu_standard_1' => 'TEdu-1', 'edu_standard_2' => 'TEdu-2', 'han_taiyu_keyu2' => 'TTaiKe',
		'j_jinmei' => 'JJinmei', 'j_joyo' => 'JJoyo', 'sjis-1' => 'JIS-1', 'sjis-2' => 'JIS-2'}

Dir.glob('*.txt').each { |fn|
	next if fn =~ /charsets/
	
	f = File.open(fn, 'r:utf-8')
	cjk = '0' * max #21000
	ext = []
	cnt = 0
	f.each { |s|
		s.chomp!
		next if s == ''
		next if s[0] == '#'
		
		c, u, x = s.split(/\t/)
		d = u.to_i(16)
		cnt += 1
		if (0x4E00..0x9FFF).include?(d)
			cjk[d - 0x4E00] = '1'
		else
			ext << u  # += sprintf('%05x', d).upcase
		end
	}
	f.close
	
	cx = ''
	(max/6).times.each { |i|
		cx += zp[cjk[i*6 ... (i+1)*6].reverse.to_i(2)]
	}
	
	fk = fn.gsub(/\.txt/, '')
	cs = fmap[fk]
	
	fx.puts "\t'#{cs}': { 'cnt': #{cnt},"
	fx.puts "\t\t'map': '#{cx}',"
	fx.puts "\t\t'ext': '#{ext.join(' ')}'},"

#	fx.puts "\t\tmap: [" + cx.join(',') + '],'
#	fx.puts "\t\text: [" + ext.join(',') + '] },'
}
fx.close