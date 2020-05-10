class Intro < Chingu::GameState
  def initialize
    super
    Chingu::Text.create("Gilbert Ruby", x: 350, y: 0, size: 50 )
    Chingu::Text.create("Master Developer---> Junior Rengifo", x: 0, y: 150, size: 40)
    Chingu::Text.create("Desing Gilbert---> Duglas Montoya", x: 0, y: 200, size: 40)
    Chingu::Text.create("Presiona Space para comenzar", x: 0, y: 300, size: 30)
    self.input = {space: Field}
  end
end