require 'chingu'
include Gosu
include Chingu

require_rel 'game_objects/*'
require_rel 'game_state/*'
def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class Game < Chingu::Window
  def initialize
    super(900, 600, false)
    self.caption = "Gilbert Ruby"
    self.input = {escape: :exit}
    push_game_state(Intro)
  end
end

Game.new.show