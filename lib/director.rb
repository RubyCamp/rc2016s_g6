require 'singleton'
require_relative 'Ginchaku'
require_relative 'map'
require_relative 'Obake'
require_relative 'Player'
require_relative 'Same'
require_relative 'Takara'
require_relative 'awa'
require_relative 'esa'

class Director
	TIME_LIMIT = 1000000
	include Singleton
	attr_reader :map, :same, :player

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
		points = []
		10.times do
			point = [rand(@map.width), rand(@map.height)] #場所ランダム
			if points.any? == point
				redo
			end
			points << point
			@takaras << Takara.new(point[0],point[1])
		end
		@characters += @takaras
		@enemies = []
		@ghosts = []
		6.times { @ghosts << Ghost.new(rand(@map.width), rand((@map.height*3/4)..@map.height)) }
		@enemies += @ghosts
		@enemies << Ginchaku.new(rand(@map.width), rand(@map.height))
		2.times { @enemies << Same.new(rand(@map.width), rand((@map.height*3/4)..@map.height)) }
		@characters += @enemies
		@player = Player.new
		@characters << @player
		@characters.each do |char|
			char.target = @render_target
		end
	end

	def play
		if game_over?
			Scene.set_current_scene(:ending)
		end
				
		count_down
		Sprite.update(@characters)
		Sprite.check(@characters, @characters, :hit, :attacked)
		Sprite.clean(@characters)
		@render_target.draw(0,0,@map.draw)

		Sprite.draw(@characters)
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
end