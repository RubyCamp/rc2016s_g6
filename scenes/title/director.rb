module Title
	class Director
		def initialize
			@bg_img = Image.load("images/title.png")
			@red = Image.new(800, 600, [255, 0, 0])
			@alpha = 0
		end

		def play
			@alpha += 0.3 if @alpha < 80
			Window.draw(0, 0, @bg_img)
			Window.draw_alpha(0, 0, @red, @alpha)
			if Input.keyPush?(K_SPACE)
				Scene.set_current_scene(:tutorial)
			end
		end
	end
end
