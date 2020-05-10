class Moneda < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def initialize(options = {})
    super
    @animation = Animation.new(file: "media/Moneda.png")
    self.scale = 0.5
  end

  def update
    @image = @animation.next
  end
end