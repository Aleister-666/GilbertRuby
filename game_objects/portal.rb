class Portal < Chingu::GameObject
  traits :collision_detection, :bounding_box

  def setup
    @animation = Animation.new(file: 'media/Portales/Portal4.png', delay: 2000)
    # self.scale = 0.9
    # @image = @animation.first
  end

  def update
    @image = @animation.next!
  end

end