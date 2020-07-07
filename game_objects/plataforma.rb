class Plataforma < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base mediana.png']
  end
end