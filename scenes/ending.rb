require_relative '../lib/score'

class Ending #定数と@color1及び2の数字を変える
	X1 = 200
	Y1 = 400
	SIZE1 = 40
	X2 = 500
	Y2 = 400
	SIZE2 = 30
	BIRITU = 2
	def initialize
		@color1 = [0,0,0]
		@color2 = [0,0,0]
		@font1 = Font.new(SIZE1)
		@font2 = Font.new(SIZE2)
		@score = nil
		@img_clear = Image.load("images/gameclear.png")
		@img_gameover = Image.load("images/gameover.png")
		@img = nil
		@top5 = []
	end

	def play
		if @score == nil
			life = Director.instance.player.life
			if Director.instance.time_count == 0
				@img = @img_gameover
				life = 0
			else
				@img = @img_clear
			end
			@score = Director.instance.player.score + Director.instance.time_count * BIRITU + life
			@score_ins  = Score.new(@score)
			@ranking = @score_ins.score
			@string = "ランキング外"
			@ranking.each_with_index do |score, rank|
				if score == @score
					@string = "    #{rank + 1}位"
					@string.concat("！") if rank < 5
					break
				end
			end
			5.times do |i|
				@top5 << (i + 1).to_s + "位: " + @ranking[i].to_s if @ranking[i]
			end
			@top5 = @top5.join("\n")
		end
		Window.draw(0, 0, @img)
		Window.draw_font(X1, Y1, "得点: #{@score}\n\n#{@string}", @font1, color:@color1)
		Window.draw_font(X2, Y2, "#{@top5}", @font2, color:@color2)
		if Input.keyPush?(K_SPACE)
			exit
		end
	end
end
