class Portal < Chingu::GameObject
  traits :collision_detection, :bounding_box

  def setup
    @animation = Animation.new(file: "media/Portal.png", size: [100, 165])
    @image = @animation.next
  end

  def update
    @image = @animation.next!
  end
end