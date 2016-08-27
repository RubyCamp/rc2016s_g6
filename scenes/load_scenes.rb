require_relative 'title'
require_relative 'tutorial'
require_relative 'mapselect'
require_relative '../lib/director'
require_relative 'ending'

Scene.add_scene(Title.new, :title)
Scene.add_scene(Tutorial.new, :tutorial)
Scene.add_scene(MapSelect.instance, :mapselect)
Scene.add_scene(Director.instance, :play)
Scene.add_scene(Ending.new, :ending)
