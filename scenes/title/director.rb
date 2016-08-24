module Title
	class Director
		def initialize
			@bg_img = Image.load("images/title.png")
		end

		def play
			Window.draw(0, 0, @bg_img)
			if Input.keyPush?(K_SPACE)
				Scene.set_current_scene(:play)
			end
		end
	end
end
