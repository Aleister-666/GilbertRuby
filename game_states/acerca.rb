class Acerca < Chingu::GameState
  def initialize(**options)
    super
    self.input = {q: proc{pop_game_state}}
    @background = Image['Acerca.png']
    PulsatingText.create('Gilbert Ruby', x: $window.width / 2, y: 50, size: 70)
    direccion = File.join(ROOT, 'lib', 'texto_acerca.txt')
    inputs = File.read(direccion)
  
    Chingu::Text.create(inputs, x: 0, y: 85, size: 30, color: Gosu::Color::WHITE, align: :center, max_width: $window.width)
    Chingu::Text.create('Developer---> Github:Aleister-666', x: 50, y: 365, size: 60, color: Gosu::Color::FUCHSIA)
    Chingu::Text.create('Backgrounds---> @crisangel', x: 150, y: 430, size: 60, color: Gosu::Color::BLUE)
    Chingu::Text.create('Pulsa Q Para Regresar', x: 240, y: $window.height - 100, size: 50, color: Gosu::Color::RED)
  end

  def draw
    @background.draw(0, 0, 0)
    super
  end
end
