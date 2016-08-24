
#require_relative '../lib/Ginchaku'
require_relative '../../lib/map'
#require_relative '../lib/Obake'
#require_relative '../lib/Player'
#require_relative '../lib/Shame'
#require_relative '../lib/Takara'

module Play
	class Director

		TIME_LIMIT = 1000000

		def initialize
			@start_time = Time.now
			@time_count = TIME_LIMIT
			@render_target = RenderTarget.new(800, 600)

			@map = Map.new("images/map.dat")	
#			@info_window = InfoWindow.new()
			@characters = []
			@takaras = []
#			10.times do
#				point = [] #場所ランダム
#				if 
#					redo
#				end
#				@takaras << Takara.new()	#引数ううう
#			end
#			@characters += @takaras
			@enemies = []
#			@enemies << Ginchaku.new()	#引数ううう
#			2.times { @enemies << Shame.new() }	#引数ううう
#			@characters += @enemies
#			@player = Player.new
#			@characters << @player
#			@characters.each do |char|
#				char.target = @render_target
#			end

		end

		def play
			if game_over?
				Scene.set_current_scene(:ending)
			end
			count_down

#			Sprite.update(@characters)
#			Sprite.check(@enemies. @player)
#			Sprite.check(@player, @takaras)
#			compact
			@map.draw
#			@info_window.draw
#			Sprite.draw(@characters)

		end

		private
		def count_down
			@time_count = TIME_LIMIT - (Time.now - @start_time).to_i
#			@info_window.count = @time_count
		end

		def game_over?
			return @time_count <= 0
		end

		def compact
=begin
			[@takaras, @characters].each do |sprites|
				sprites.regect { |sprite| sprite.vanished? }
			end
=end
		end
	end
end
