require_relative 'title/director'
require_relative 'tutorial/tutorial'
require_relative '../lib/director'
require_relative 'ending/director'

Scene.add_scene(Title::Director.new, :title)
Scene.add_scene(Tutorial.new, :tutorial)
Scene.add_scene(Director.instance, :play)
Scene.add_scene(Ending.new, :ending)
