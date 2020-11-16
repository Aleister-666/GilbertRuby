class Lose < Chingu::GameState
  traits :viewport, :timer

  def initialize
    super
    @seg = 3
    msj = Chingu::Text.create('Has Perdido Pendejo. VUELVE A EMPEZAR', x: 150, y: 150, size: 30)
    msj2 = Chingu::Text.create(decrement, x: 150, y: 200, size: 30)

    after(800) { @seg -= 1; msj2.text = decrement }
    after(1600) { @seg -= 1; msj2.text = decrement }
    after(2400) do
      pop_game_state
      game_states[select_game_state('Puntajes')].pop_game_state(setup: false)
      game_states[select_game_state('Level2')].pop_game_state if game_state_exist?('Level2')
      game_states[select_game_state('Level1')].music.play if game_states[select_game_state('Level1')].sonido
    end
  end

  # Metodo que contiene el mensaje que en un ciclo se podra actualizar 
  def decrement
    "Espera #{@seg} segundos para comenzar de nuevo"
  end

  def draw
    if game_state_exist?('Level2')
      game_states[select_game_state('Level2')].draw
    else
      game_states[select_game_state('Level1')].draw
    end
    super
  end

  private

  # Retorna Encuentra y retorna el indice de la GameState que se balla a usar
  def select_game_state(klass)
    game_states.each_with_index do |value, index|
      return index if value.class.to_s === klass
    end
    nil
  end

# Metodo para buscar y verificar si una GameState existe.
# Se le pasa por parametro el nombre de la clase del GameState.
# Si existe retorna verdadero, en caso contrario retorna falso
  def game_state_exist?(klass)
    game_states.each do |value|
      return true if value.class.to_s === klass
    end
    false
  end
end
