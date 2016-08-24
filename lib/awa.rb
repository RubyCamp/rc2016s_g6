class Awa < Sprite

	#生成する座標が引数
	def initialize(a, b)
		self.image = Image.load('images/awa.png')
		self.image.set_color_key(C_WHITE)
		self.x, self.y = a, b
	end


	#プレイヤーにぶつかったら泡が消えるようにする
	def hit(obj)
		if obj.is_a?(Player)
			self.vanish
		end
	end

end