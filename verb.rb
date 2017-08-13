
class Verb
	def initialize
		@default = "I don't understand."
	end
	def action (*args)
		"Default Verb action, args: " + args.join(", ")
	end
end



class Look < Verb
	def initialize
		@default = $area_ref.look  if $area_ref
		#@default = "Default look output."
	end

	def action (p=false,opts=false)
		return $area_ref.look  if p == false

		if (p.class == Class)
			return p.new.look
		else
			p.look
		end
	end
end


class Go < Verb
	def initialize
		@default = "I can't go there."
	end

	def action (area=false, opts=false)
		if (area && opts[:area_sym])
			$area = opts[:area_sym]
			$area_ref = area
			$area_neighbors = []
			$area_neighbors = AREA_MAP[opts[:area_sym]]
		else
			ret = "I can go to "
			if ($area_neighbors.length > 1)
				$area_neighbors.each_with_index do |nb,i|
					if (i < $area_neighbors.length - 1)
						ret += "#{nb.to_s.gsub("_"," ")}, "
					else
						ret += "and #{nb.to_s.gsub("_"," ")}."
					end
				end
			elsif ($area_neighbors.length == 1)
				ret += "#{$area_neighbors[0].to_s.gsub("_"," ")}."
			elsif ($area_neighbors.length == 0)
				ret = "I can't go anywhere."
			end
			return ret
		end
	end
end


class Take < Verb
	def initialize
	end

	def action (item)
		$area_ref.items.each do |i|
			if (i == item)
				add_item item
				$area_ref.items.delete item
			end
		end
	end
end



VERBS = [

	[[:look,:inspect], Look.new],
	[[:go,:move,:walk,:run], Go.new],
	[[:take,:pick,:pickup], Take.new]

]

