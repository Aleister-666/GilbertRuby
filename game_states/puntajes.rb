# Clase para generar game_state de puntajes.
# Aqui se exponen los puntajes logrados en los niveles
class Puntajes < Chingu::GameState

  def initialize(**options)
    super
    @player_name = options[:player_name]
    @score = options[:score]
    @difficulty = options[:difficulty]
    @sonido = options[:sonido]

    @background = Image['Acerca.png']
    @reset = Image['Reiniciar.png']
    @reset_msj = Chingu::Text.new('Reset', x: 95, y: 45, size: 20, color: Gosu::Color::WHITE)

    @salir = Image['Salir.png']
    @exit_msj = Chingu::Text.new('Exit', x: 770, y: 45, size: 20, color: Gosu::Color::WHITE)

    @marcador = HighScoreList.load(size: 9)
    @titulo = PulsatingText.create('PUNTAJES', x: $window.width / 2, y: 50, size: 70)
    add(@player_name, @score, @difficulty)

    self.input = { r: :reiniciar}
  end

	# Agrega los datos del jugador al registro en pantalla
  def add(name, score, difficulty)
    data = { name: name, score: score, difficulty: difficulty, text: 'Gilbert Ruby Puntajes' }
    position = @marcador.add(data)
    create_text
  end

	# Metodo para crear el texto en pantalla
  def create_text
    @marcador.each_with_index do |high_score, index|
      y = (index * 40) + 150
      Text.create(high_score[:name], x: @titulo.x - 300, y: y, size: 40)
      Text.create(high_score[:score], x: @titulo.x + 45, y: y, size: 40, color: Gosu::Color::YELLOW)
      Text.create(high_score[:difficulty], x: @titulo.x + 150, y: y, size: 40)
    end
  end

  def reiniciar
    push_game_state(Lose.new(player_name: @player_name, difficulty: @difficulty, sonido: @sonido))
  end

  def draw
    @background.draw(0, 0, 0)
    @reset.draw(25, 25, 0)
    @reset_msj.draw
    @salir.draw(810, 25, 0)
    @exit_msj.draw
    super
  end
end
