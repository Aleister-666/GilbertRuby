class Base < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base.png']
  end
end