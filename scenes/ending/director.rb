require_relative '../../lib/score'

class Ending
	def initialize
		@font1 = Font.new(40)
		@font2 = Font.new(25)
		@score = nil
#		@bg_img = Image.load("images/?????????????.png")
	end

	def play
		if @score == nil
			@score = Director.instance.player.score + Director.instance.time_count
			@scorei  = Score.new(@score)
			@ranking = @scorei.top_score
			@string = @ranking.join("\n")
		end
#		Window.draw(0, 0, @bg_img)
		Window.draw_font(400, 200, "得点: #{@score}", @font1)
		Window.draw_font(500, 300, "ランキング: #{@string}", @font2)
		if Input.keyPush?(K_SPACE)
			exit
		end
	end
end
