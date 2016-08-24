require 'singleton'
require_relative 'Ginchaku'
require_relative 'map'
require_relative 'Obake'
require_relative 'Player'
require_relative 'Same'
require_relative 'Takara'
require_relative 'awa'
require_relative 'esa'
require_relative 'info_window'

class Director
	TIME_LIMIT = 100
	GHOST_APPEAR_TIME = 3 * 60
	include Singleton
	attr_reader :map, :same, :player, :time_count

	def initialize
		@start_time = Time.now
		@time_count = TIME_LIMIT
		@map = Map.new("images/map.dat")
		@render_target = RenderTarget.new(@map.width, @map.height)

		@info_window = InfoWindow.new(@time_count)
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
		@objects = []
		@ghosts_pos_x = []
		@ghosts_pos_y = []
		@ghosts_count = []
		@ghosts = []
#		6.times { @ghosts << Ghost.new(rand(@map.width), rand((@map.height/4)..@map.height)) }
#		@enemies += @ghosts
		@objects << Ginchaku.new(rand(@map.width), rand(@map.height))
		3.times { @objects << Awa.new(rand(@map.width), rand(@map.height)) }
		@characters += @objects
		2.times { @enemies << Same.new(rand(@map.width), rand((@map.height/4)..@map.height)) }
		@characters += @enemies
		@player = Player.new
		@characters << @player
		@characters.each do |char|
			char.target = @render_target
		end
	end

	def play
		count_down
		Sprite.update(@characters)
		Sprite.check(@characters, @characters)
		@takaras.each do |takara|
			if takara.vanished?
				@ghosts_pos_x << takara.x
				@ghosts_pos_y << takara.y
				@ghosts_count << GHOST_APPEAR_TIME
			end
		end
		@ghosts_count.each_with_index do |count, i|
			@ghosts_count[i] -= 1 if count >= 0
			if count == 0
				x = @ghosts_pos_x[i]
				y = @ghosts_pos_y[i]
				@ghost = Ghost.new(x,y)
				@ghost.target = @render_target
				@ghosts << @ghost
				@enemies << @ghost
				@characters << @ghost
			end
		end
		Sprite.clean(@characters)
		Sprite.clean(@takaras)
		@render_target.draw(0,0,@map.draw)
		Sprite.draw(@characters)
		Window.draw(-@player.pos_x,-@player.pos_y,@render_target)
		@info_window.draw
		if game_over?
			@time_count = 0
			Scene.set_current_scene(:ending)
		end
	end

	private
	def count_down
		@time_count = TIME_LIMIT - (Time.now - @start_time).to_i
		@info_window.count = @time_count
	end

	def game_over?
		return @time_count <= 0 || @player.life <= 0 || @player.vanished?
	end
end
