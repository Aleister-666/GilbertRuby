class Moneda < Chingu::GameObject
  trait :bounding_circle, debug: false
  traits :collision_detection
  def setup
    @animation = Animation.new(file: "media/Moneda.png")
    @image = @animation.next
    @collect_coin = Song.new("media/mario-coin.mp3")
    self.scale = 0.5
    cache_bounding_circle
  end

  def update
    @image = @animation.next
  end

  def play_sound
    @collect_coin.play
  end
end