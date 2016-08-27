class Title
	def initialize
		@bg_img = Image.load("images/title.png")
		@red = Image.new(800, 600, [255, 0, 0])
		@alpha = 0
		@flg = false
		@font = Font.new(30)
		@count = 0
	end

	def play
		if Input.keyPush?(K_DELETE)
			@flg = true
		end
		@alpha += 0.3 if @alpha < 80
		Window.draw(0, 0, @bg_img)
		Window.draw_alpha(0, 0, @red, @alpha)
		if Input.keyPush?(K_SPACE)
			Scene.set_current_scene(:tutorial)
		end
		if @flg == true
			Window.draw_font(190, 270,"セーブデータを削除しますか？\n     press   \"Y\" or \"N\"",@font)
			if Input.keyPush?(K_Y)
				score_delete
				@flg = false
			elsif Input.keyPush?(K_N)
				@flg = false
			end
		end
		if @count > 0
			@count -= 1
			Window.draw_font(190, 270, "セーブデータを削除しました", @font)
		end
	end
	def score_delete
		Dir.open("score") do |dir|
			dir.each do |name|
				if /^map.*_score\.dat$/ =~ name
					file = "score/" + name
					File.delete(file)
				end
			end
		end
		@count = 60
	end
end
