class Tutorial
	def initialize
#		@bg_imag = Image.load("images/???????.png")
	end

	def play
#		Window.draw(0, 0, @bg_imag)
		if Input.keyPush?(K_SPACE)
			Scene.set_current_scene(:play)
		end
	end
end
