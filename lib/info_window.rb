class InfoWindow
	attr_writer :count

	def initialize(count)
		@font = Font.new(32)
		@count = count
	end

	def draw
		Window.draw_font(10, 10, "残り時間: #{@count}", @font)
	end
end
