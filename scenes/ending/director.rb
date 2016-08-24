class Ending
	def initialize
		@font = Font.new(40)
#		@bg_img = Image.load("images/background_title.png")
	end

	def play
#		Window.draw(0, 0, @bg_img)
		Window.draw_font(400, Window.height / 2, "得点: #{Director.instance.player.score + Director.instance.time_count}", @font)
		if Input.keyPush?(K_SPACE)
			exit
		end
	end
end
