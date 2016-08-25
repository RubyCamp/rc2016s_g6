class Awa < Sprite

	@@images

	#生成する座標が引数
	def initialize(a, b)
		@@images = []
		@@images << Image.load('images/awa.png')
		@@images << Image.load('images/awa1.png')
		@@images << Image.load('images/awa2.png')
		@@images << Image.load('images/awa3.png')
		self.image = @@images[0]
		self.image.set_color_key(C_WHITE)
		self.x, self.y = a, b
		@cnt = 0
		@time = 0
	end

	def update
		@cnt %= 4
		@time += 1
		if @time == 10
			self.image = @@images[@cnt]
			self.image.set_color_key(C_WHITE)
			@cnt += 1
			@time = 0
		end

	end

	#プレイヤーにぶつかったら泡が消えるようにする
	def hit(obj)
		if obj.is_a?(Player)
			self.vanish
		end
	end

end