
class Verb

	def initialize
		
	end

	def index (p)
		return @default  unless p

		# for item
		action p
	end

end



class Look < Verb
	def initialize
		#@default = @@cur_area.describe
		@default = "Default look output."
	end

	def action (p)
		p.describe
	end
end


class Go < Verb
	def initialize
		@default = "I can't go there."
	end
end



VERBS = [

	[[:look,:inspect], Look.new],
	[[:go,:move,:walk,:run], Go.new]

]

