class Acerca < Chingu::GameState
  def initialize(options = {})
    super
    self.input = {q: proc{pop_game_state}}
    @background = Image['Acerca.png']
    PulsatingText.create("Gilbert Ruby", x: $window.width / 2, y: 50, size: 70)
    direccion = File.join(ROOT, "lib", "texto_acerca.txt")
    inputs = File.read(direccion)
    
    Chingu::Text.create(inputs, x: 0, y: 85, size: 30, color: Gosu::Color::WHITE, align: :center, max_width: $window.width)
    Chingu::Text.create("Master Developer---> Aleister-666", x: 150, y: 400, size: 40, color: Gosu::Color::FUCHSIA)
    Chingu::Text.create("Desing Gilbert And Level's---> 4n70n10-pixel", x: 145, y: 450, size: 40, color: Gosu::Color::BLUE)
    Chingu::Text.create("Pulsa Q Para Regresar", x: 240, y: $window.height - 100, size: 50, color: Gosu::Color::RED)
  end

  def draw
    @background.draw(0, 0, 0)
    super
  end
end