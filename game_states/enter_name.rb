class EnterName < Chingu::GameStates::EnterName
  def initialize(options = {})
    self.input = { q: proc { pop_game_state } }
    super
    PulsatingText.create('Introduce Un Nombre', x: $window.width / 2, y: 45, size: 70)
    Chingu::Text.create('Maximo 18 Caracteres', x: $window.width / 2 - 400, y: $window.height - 250, size: 90, color: Gosu::Color::YELLOW)
    Chingu::Text.create('Q: Regresar', x: $window.width / 2 - 400, y: $window.height - 45, size: 30)
    @background = Image['Acerca.png']
    @select_song = Sample.new('media/Songs/menuselect.ogg')
  end

  def move_cursor(amount)
    super
    @select_song.play
  end

  def action
    super
    @select_song.play
  end

  def draw
    @background.draw(0, 0, 0)
    super
  end
end
