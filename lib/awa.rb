class Awa < Sprite

	#生成する座標が引数
	def initialize(a, b)
		self.imgae("images/awa.png")
		self.image.set_color_key(C_WHITE)
		self.x, self.y = a, b
	end

	
end