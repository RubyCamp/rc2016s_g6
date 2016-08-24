class InfoWindow
	attr_writer :count

	def initialize(count)
		@font = Font.new(25)
		@count = count
	end

	def draw
    player = Director.instance.player
    Window.draw_font(10, 10, "残り時間: #{@count}", @font)
    Window.draw_font(200, 10, "ライフ: #{player.life.to_i}", @font)
    Window.draw_font(400, 10, "得点: #{player.score}", @font)
	end
end
