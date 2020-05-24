class Intro < Chingu::GameState
  def initialize
    super
    Chingu::Text.create("Gilbert Ruby", x:320, y: 0, size: 50, color: Gosu::Color::RED)
    inputs = <<~INPUT 
    Bienvenidos al GIlbert Ruby, tu Objetivo sera agarrar el mayor numero de monedas posibles.
    Mover-Derecha: Flecha-Derecha. Mover-Izquierda: Flecha-Izquierda.
    Saltar: Flecha-Arriba, Spacio.
    Correr: Z.
    INPUT
    Chingu::Text.create(inputs, x: 0, y: 50, size: 30, color: Gosu::Color::GRAY, align: :center, max_width: $window.width)

    Chingu::Text.create("Master Developer---> Junior Rengifo", x: 150, y: 250, size: 40, color: Gosu::Color::FUCHSIA)
    Chingu::Text.create("Desing Gilbert---> Duglas Montoya", x: 150, y: 300, size: 40, color: Gosu::Color::BLUE)
    Chingu::Text.create("Presiona Enter para comenzar", x: 150, y: $window.height - 100, size: 50, color: Gosu::Color::RED)
    self.input = {return: :enter_name_window}
  end

  def enter_name_window
  	#push_game_state(EnterName)
    push_game_state(Chingu::GameStates::EnterName.new(callback: method(:enter_name)))
  end
  def enter_name(name)
    @player_name = name
  end

  def player_name
    return @player_name
  end

  def update
    super
    if  @player_name
      push_game_state(Level1)
    end
  end
end

=begin
class EnterName < Chingu::GameState

  def draw
    super
    push_game_state(Chingu::GameStates::EnterName.new(callback: method(:nombre)))
  end

  def nombre(name)
    @nombre = name
    puts @nombre
    return @nombre
  end


  def update
    super
    puts current_game_state
    if @nombre
      push_game_state(Level1)
    end

  end
end
=end