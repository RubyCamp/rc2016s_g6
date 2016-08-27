class Score

	attr_accessor :score

	#新しいスコアが引数
	def initialize(score)
		map = MapSelect.instance.map.sub("images/", "score/").sub(".", "_score.")
		@io = File.open(map, "a+")
		self.score = []
		self.score << score
		self.loadscore
		self.score.sort!
		self.score.reverse!
		self.writescore
	end

	#スコアを読み込むメソッド
	def loadscore
		ary = @io.readlines
		ary.each do |line|
			line.chomp!
			self.score << line.to_i
		end
	end
 
 	#スコアを書き込むメソッド
	def writescore
		@io.truncate(0)
		cnt = 0
		@score.each do |s|
			@io.puts(s.to_s)
			cnt += 1
			if cnt > 100
				break
			end
		end
		@io.close
	end
end