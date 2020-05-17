class Plataforma < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base corta.png']
  end
end