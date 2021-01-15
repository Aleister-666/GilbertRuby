class Lose < Chingu::GameState
  traits :viewport, :timer

  def initialize(**options)
    super
    @player_name = options[:player_name]
    @difficulty = options[:difficulty]
    @sonido = options[:sonido]

    @background = Image['Bg lose.png']

    @seg = 3
    palabras = ["Perdiste Pendejo", "Puedes mejorar", "Tu puedes"]
    Chingu::Text.create("#{palabras.sample.upcase}. VUELVE A EMPEZAR",
                        x: 0,
                        y: 150,
                        size: 50,
                        color: Gosu::Color::YELLOW)
    msj2 = Chingu::Text.create(decrement, x: 100, y: 280, size: 40)

    after(800) { @seg -= 1; msj2.text = decrement }
    after(1600) { @seg -= 1; msj2.text = decrement }
    after(2400) do
      pop_game_state
      game_states[select_game_state('Puntajes')].pop_game_state(setup: false)
      # game_states[select_game_state('Level3')].pop_game_state if game_state_exist?('Level3')
      # game_states[select_game_state('Level2')].pop_game_state if game_state_exist?('Level2')
      # game_states[select_game_state('Level1')].music.play if game_states[select_game_state('Level1')].sonido
      push_game_state(Level1.new(player_name: @player_name, score: 0, sonido: @sonido, difficulty: @difficulty))
    end
  end

  # Metodo que contiene el mensaje que en un ciclo se podra actualizar
  def decrement
    "Espera #{@seg} segundos para comenzar de nuevo"
  end

  def draw
    @background.draw(0, 0, 0)
    super
  end

  private

  # Retorna Encuentra y retorna el indice de la GameState que se balla a usar
  def select_game_state(klass)
    game_states.each_with_index do |value, index|
      return index if value.class.to_s == klass
    end
    nil
  end

# Metodo para buscar y verificar si una GameState existe.
# Se le pasa por parametro el nombre de la clase del GameState.
# Si existe retorna verdadero, en caso contrario retorna falso
  def game_state_exist?(klass)
    game_states.each do |value|
      return true if value.class.to_s == klass
    end
    false
  end
end
