#えさ用のクラス特に
#動作はない
class Esa < Sprite

	#えさを生成する座標が引数
	def initialize(a, b)
		super
		self.image = Image.load(image_path("esa.png"))
		self.x, self.y = a, b
	end

	def image_path(filename)
  	return File.join(File.dirname(__FILE__), "..", "images", filename)
 	end
 end