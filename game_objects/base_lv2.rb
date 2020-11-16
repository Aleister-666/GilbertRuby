class BaseLv2 < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['baseLv2.png']
  end
end