require 'singleton'
#require_relative 'Ginchaku'
require_relative 'map'
#require_relative 'Obake'
#require_relative 'Player'
#require_relative 'Shame'
#require_relative 'Takara'
#require_relative 'awa'
#require_relative 'esa'

class Director
	TIME_LIMIT = 1000000
	include Singleton
	attr_reader :map
#:player

	def initialize
		@start_time = Time.now
		@time_count = TIME_LIMIT
		@map = Map.new("images/map.dat")
		@render_target = RenderTarget.new(@map.width, @map.height)
		@x = 0
		@y = 0
	
#		@info_window = InfoWindow.new()
		@characters = []
		@takaras = []
#		10.times do
#			point = [] #場所ランダム
#			if 
#				redo
#			end
#			@takaras << Takara.new()	#引数ううう
#		end
#		@characters += @takaras
		@enemies = []
#		@enemies << Ginchaku.new()	#引数ううう
#		2.times { @enemies << Shame.new() }	#引数ううう
#		@characters += @enemies
#		@player = Player.new
#		@characters << @player
#		@characters.each do |char|
#			char.target = @render_target
#		end

	end

	def play
		if game_over?
			Scene.set_current_scene(:ending)
		end
		if Input.keyPush? (K_UP)
			@y += 100
		elsif Input.keyPush? (K_DOWN)
			@y -= 100
		elsif Input.keyPush? (K_RIGHT)
			@x -= 100
		elsif Input.keyPush? (K_LEFT)
			@x += 100
		end
				
		count_down
#		Sprite.update(@characters)
#		Sprite.check(@enemies. @player)
#		Sprite.check(@player, @takaras)
#		compact
		@render_target = @map.draw
#		@render_target.draw(0,0,@map.draw)
#		@render_target2.draw(0,0,@map.draw)

#		Sprite.draw(@characters)
		Window.draw(@x,@y,@render_target)
#		@info_window.draw

	end

	private
	def count_down
		@time_count = TIME_LIMIT - (Time.now - @start_time).to_i
#		@info_window.count = @time_count
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