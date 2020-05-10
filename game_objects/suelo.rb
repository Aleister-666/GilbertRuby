class Suelo < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def initialize(options = {})
    super
    @image = if options[:corta] == true
               Image['base corta.png']
             else
               Image['base.png']
             end
  end
end