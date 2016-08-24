class Ginchaku < Sprite

	def initialize(a, b)
		super
		self.x, self.y = a, b
		self.image = Image.load("images/ginchaku.png")
		self.image.set_color_key(C_WHITE)
	end

end
