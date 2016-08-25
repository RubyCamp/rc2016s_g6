require 'dxruby'
#require_relative 'lib/director'
require_relative 'scene'
require_relative 'lib/score'
require_relative 'scenes/load_scenes'


Window.width = 800
Window.height = 600

Scene.set_current_scene(:title)

Window.loop do
	break if Input.keyPush?(K_ESCAPE)
	
	Scene.play_scene
end