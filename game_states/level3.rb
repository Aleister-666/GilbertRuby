class Level3 < Chingu::GameState
  traits :viewport, :timer
  GAME_OBJECTS = [Moneda, MonedaPlata, MonedaOro].freeze
  def initialize(options = {})
    super
    @player_name = options[:player_name].capitalize
    @sonido = options[:sonido]
  end
end
