class Tutorial
	def initialize
			@bg_imag = Image.load("images/how_to_play1.png")
			@count = 0
	end

	def play
		Window.draw(0, 0, @bg_imag)
		if Input.keyPush?(K_SPACE)
			if @count == 0
				@bg_imag = Image.load("images/how_to_play2.png")
				@count += 1
			else
				Scene.set_current_scene(:mapselect)
			end
		end
	end
end
