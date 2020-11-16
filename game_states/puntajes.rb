class Puntajes < Chingu::GameState
  def initialize(options = {})
    super
    @player_name = options[:player_name]
    @score = options[:score]
    @background = Image['Acerca.png']
    self.input = { r: proc { push_game_state(Lose) } }
    @reset = Image['Reiniciar.png']
    @salir = Image['Salir.png']
    @marcador = HighScoreList.load(size: 9)
    @titulo = PulsatingText.create('PUNTAJES', x: $window.width / 2, y: 50, size: 70)
    add(@player_name, @score)
  end

	# Agrega los datos del jugador al registro en pantalla
  def add(name, score)
    data = { name: name, score: score, text: 'Gilbert Ruby Puntajes' }
    position = @marcador.add(data)
    create_text
  end

	# Metodo para crear el texto en pantalla
  def create_text
    @marcador.each_with_index do |high_score, index|
      y = index * 25 + 100
      Text.create(high_score[:name], x: @titulo.x - 300, y: y, size: 30)
      Text.create(high_score[:score], x: @titulo.x, y: y, size: 30)
    end
  end

  def draw
    @background.draw(0, 0, 0)
    @reset.draw(25, 25, 0)
    @salir.draw(810, 25, 0)
    super
  end
end
