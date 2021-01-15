class RechargeStation < Chingu::GameObject
  traits :collision_detection, :bounding_box

  def setup
    @animation = Animation.new(file: 'media/Recharge Station.png', size: [100, 165])
    @image = @animation.next
  end

  def update
    @image = @animation.next!
  end
end