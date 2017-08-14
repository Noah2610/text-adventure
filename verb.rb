
class Verb
	def initialize
		@default = "I don't understand."
		self.init
	end
	def action (*args)
		"Default Verb action, args: " + args.join(", ")
	end
end



class Look < Verb
	def init
		@default = $area_ref.look  if $area_ref
		#@default = "Default look output."
	end

	def action (instance=false,opts=false)
		return $area_ref.look  if instance == false

		if (instance.class == Class)
			return instance.new.look
		else
			instance.look
		end
	end
end


class Go < Verb
	def init
		@default = "I can't go there."
	end

	def action (area=false, opts=false)
		if (area && opts[:area_sym])
			return @default  unless area.is_area?
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
		""
	end
end


class Take < Verb
	def init
	end

	def action (item=false)
		return "Take what?"  unless item
		$inventory.each do |i|
			return "I already grabbed #{i[1].name}."  if (i[1] == item)
		end

		$area_ref.items.delete item
		add_item item
		$inventory.last[1].take
	end
end


class Talk < Verb
	def init
	end

	def action (person=false,opts=false)
		return "To who do I want to talk?"  unless person
		if person.is_person?
			$interaction_state = :talk
			$talking_to = person
			return person.talk

		elsif person.is_item?
			return "I can't talk to #{person.name.to_s}."
		elsif person.is_area?
			return "I can't talk to #{person.name.to_s}."
		else
			return "I don't understand."
		end
	end
end



VERBS = [

	[[:look,:inspect], Look.new],
	[[:go,:move,:walk,:run], Go.new],
	[[:take,:pick,:pickup], Take.new],
	[[:talk,:communicate], Talk.new]

]

