require_relative '../lib/pulsating_text.rb'
class Puntajes < Chingu::GameState
	def initialize(options = {})
		super(options)
		self.input = {r: proc{push_game_state(Lose, setup: false)}, q: proc{exit}}
		Chingu::Text.create("R:Iniciar de Juego", x: 0, y: 5, size: 25, color: Gosu::Color::RED)
		Chingu::Text.create("Q:Cerrar Juego", x: $window.width - 150, y: 5, size: 25, color: Gosu::Color::RED)

		@marcador = HighScoreList.load(size: 9)
		@titulo = PulsatingText.create("PUNTAJES", x: $window.width/2, y: 50, size: 70)
		add(options[:player], options[:score])
	end

	def add(name, score)
		data = {:name => name, :score => score, :text => "Gilbert Ruby Puntajes"}
	  position = @marcador.add(data)
	  create_text
	end
	
	def create_text
    @marcador.each_with_index do |high_score, index|
      y = index * 25 + 100
      Text.create(high_score[:name], :x => @titulo.x - 300, :y => y, :size => 30)
      Text.create(high_score[:score], :x => @titulo.x, :y => y, :size => 30)
    end
  end
end