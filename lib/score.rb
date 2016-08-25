class Score

	attr_accessor :score

	#新しいスコアが引数
	def initialize(score)
		@io = File.open("lib/score.dat", "r+")
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
		@io.rewind
		@score.each do |s|
			@io.puts(s.to_s)
		end
		@io.close
	end

	#上位五名を知る配列で返すメソッド
	def top_score 
		top = []
		5.times do |i|
			top << self.score[i]
		end
		return top
	end
end