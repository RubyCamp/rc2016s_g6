require_relative '../../lib/score'

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
	end

	def play
		if @score == nil
			life = Director.instance.player.life
			if Director.instance.time_count == 0
				@img = @img_gameover
				life = 0
				@flg = true #false
			else
				@img = @img_clear
				@flg = true
			end
			@score = Director.instance.player.score + Director.instance.time_count * BIRITU + life
			@score_ins  = Score.new(@score,@flg)
			@ranking = @score_ins.top_score
			@ranking.each_with_index do |score, rank|
				if score == @score
					@string = "  #{rank + 1}位！"
					break
				end
				@string = "ランキング外"
			end if @flg
		end
		Window.draw(0, 0, @img)
		Window.draw_font(X1, Y1, "得点: #{@score}\n\n#{@string}", @font1, color:@color1)
		@ranking.each_with_index do |rank, i|
			Window.draw_font(X2, Y2 + i * SIZE2, "#{i + 1}位: #{rank}", @font2, color:@color2)
		end
		if Input.keyPush?(K_SPACE)
			exit
		end
	end
end
