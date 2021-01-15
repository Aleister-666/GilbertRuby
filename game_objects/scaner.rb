class Scaner < Chingu::GameObject

	def initialize(options = {})
		super
		case options[:metal]
		when 'bronce'
			file = 'media/FlechasBronce.png'
		when 'plata'
			file = 'media/FlechasPlata.png'
		when 'oro'
			file = 'media/FlechasOro.png'
		end

		@scaner_animacion = {}
		@scaner_animacion[:animation] = Animation.new(file: file)
		@scaner_animacion[:animation].frame_names = {up_right: 0..0, up_left: 1..1, down_right: 2..2, down_left: 3..3}
		@animation = nil
		self.scale = 0.4
	end

=begin
Especifica que frames de la animacion usar
si inverse es true los frames de la animacio seran el inverso
de la animacion descrita por el nombre del metodo
=end
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