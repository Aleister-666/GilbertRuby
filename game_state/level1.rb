class Level1 < Chingu::GameState
  attr_accessor :enter_name
  traits :viewport, :timer
  GAME_OBJECTS = [Base, Moneda, Plataforma, Plataforma2]
  def initialize
    super
    @player_name = previous_game_state().player_name.capitalize
    @player_name = "Anonymus" if @player_name.empty?
    self.input = {e: :edit}
    @background = Image['paisaje.png']
    self.viewport.lag = 0
    self.viewport.game_area = [0, 0, 3000, 1000]
    load_game_objects
    @gilbert = Gilbert.create(x: 50, y: 900)
    @contador = 0
    @marcador = Chingu::Text.new("#{@player_name}:  Puntaje: #{@contador}", x: 5, y: 5, size: 35, color: Gosu::Color::BLACK)
  end

  def edit
    push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert]))
  end

  def draw
    super
    @background.draw(0, 0, 0)
    @marcador.draw()
  end

  def reset
    # switch_game_state(Lose)
    @gilbert.x = 50
    @gilbert.y = 900
    @contador = 0
    GAME_OBJECTS.each(&:destroy_all)
    load_game_objects
    push_game_state(Lose)
  end

  def update
    super
    @marcador.text = "#{@player_name}:  Puntaje: #{@contador}"
    self.viewport.center_around(@gilbert)
    @gilbert.each_collision(Moneda) do |gilbert, moneda|
      moneda.play_sound
      @contador += 1
      moneda.destroy
    end

    if self.viewport.outside_game_area?(@gilbert)
      if @gilbert.y >= self.viewport.game_area.height
        @gilbert.y = self.viewport.game_area.height + 100
        reset
      end
    end
  end
end
