class Scaner < Chingu::GameObject

	def initialize(options = {})
		super
		if options[:metal] == "bronce"
			file = "media/FlechasBronce.png"
		elsif options[:metal] == "plata"
			file = "media/FlechasPlata.png"
		elsif options[:metal] == "oro"
			file = "media/FlechasOro.png"
		end
		@scaner_animacion = {}
		@scaner_animacion[:animation] = Animation.new(file: file)
		@scaner_animacion[:animation].frame_names = {up_right: 0..0, up_left: 1..1, down_right: 2..2, down_left: 3..3}
		@animation = nil
		self.scale = 0.4
	end

	def arriba_derecha(inverse = false)
		unless inverse
			@animation = @scaner_animacion[:animation][:up_right]
		else
			@animation = @scaner_animacion[:animation][:down_left]
		end
	end

	def abajo_derecha(inverse = false)
		unless inverse
			@animation = @scaner_animacion[:animation][:down_right]
		else
			@animation = @scaner_animacion[:animation][:up_left]
		end
	end
	

	def update
		@image = @animation.next! if @animation != nil
	end

end