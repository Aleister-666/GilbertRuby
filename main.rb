require 'gosu'
require 'chingu'

include Gosu
include Chingu

require_all 'lib/'
require_all 'game_objects/'
require_all 'game_states/'

class Game < Chingu::Window
  def initialize
    super(900, 600, false)
    self.input = {escape: :exit}
    self.caption = 'Gilbert Ruby'
    push_game_state(Menu)
  end
end

begin
 Game.new.show
rescue => e
 puts "Error: #{e}   Informacion: #{e.full_message}"
end
