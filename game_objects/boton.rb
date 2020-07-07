class Boton < Chingu::GameObject
	traits :collision_detection, :bounding_box

	def initialize(options = {})
		super
		@image = Image['Boton rojo.png']
		self.scale = 0.4
	end
end