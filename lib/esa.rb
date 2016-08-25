#えさ用のクラス特に
#動作はない
class Esa < Sprite

	#えさを生成する座標が引数
	def initialize(a, b)
		super
		self.image = Image.load(image_path("esa.png"))
		self.image.set_color_key(C_WHITE)
		self.x, self.y = a, b
		self.collision = [self.image.width / 2, self.image.height / 2, 25]
	end

	def hit(obj)
		if obj.is_a?(Same)
			vanish
		end
	end
	def image_path(filename)
  	return File.join(File.dirname(__FILE__), "..", "images", filename)
 	end
 end
