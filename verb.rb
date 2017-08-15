
class Verb
	def initialize
		@default = "I don't understand.".yellow
		self.init
	end
	def action (*args)
		"Default Verb action, args: " + args.join(", ")
	end
end



class Look < Verb
	def init
		#@default = $area.look  if $area
		#@default = "Default look output."
	end

	def action (items:[],areas:[],people:[])
		ret = []
		Array.new.concat(items,areas,people).each do |instance|
			ret.push instance.look
		end
		return ret.join("\n")  unless ret.empty?
		return $area.look
	end
end


class Go < Verb
	def init
		@default = "How would I be able to go there?"
	end

	def action (items:[],areas:[],people:[])
		return @default  if (areas.empty? && (!items.empty? || !people.empty?))
		if (!areas.empty?)
			return areas[0].goto!
			ret = areas[0].has_visited ? areas[0].name : areas[0].look
			return ret
		else
			ret = "I can go to "
			if ($area.neighbors.length > 1)
				$area.neighbors.each_with_index do |nb,i|
					if (i < $area.neighbors.length - 1)
						ret += "#{nb.to_s.gsub("_"," ")}, "
					else
						ret += "and #{nb.to_s.gsub("_"," ")}."
					end
				end
			elsif ($area.neighbors.length == 1)
				ret += "#{$area.neighbors[0].to_s.gsub("_"," ")}."
			elsif ($area.neighbors.length == 0)
				ret = "I can't go anywhere."
			end
			return ret
		end
	end
end


class Take < Verb
	def init
	end

	def action (items:[],areas:[],people:[])
		return "Now why and how would I take that?"  if (items.empty? && (!areas.empty? || !people.empty?))
		return "Take what?"  if (items.empty?)
		ret = []
		items.each do |item|
			catch (:skip_add) do
				$inventory.each do |i|
					if (i[1].class == item.class)
						ret.push "I already grabbed #{i[1].name}."
						throw :skip_add
					end
				end
				$area.rm_item item.to_sym
				add_item item.to_sym
				ret.push $inventory.last[1].take
			end
		end
		return ret.join("\n")
	end
end


class Talk < Verb
	def init
	end

	#def action (person=false,opts=false)
	def action (items:[],areas:[],people:[])
		if (!people.empty? && people[0].is_person?)
			$interaction_state = :talk
			$talking_to = people[0]
			return people[0].talk
		end
		return "I don't think that would be a very interesting conversation."  unless (items.empty? && areas.empty?)
		return "To who do I want to talk?"
	end
end


class Give < Verb
	def init
	end

	def action (items:[],areas:[],people:[])
		ret = []
		if (!items.empty? && !people.empty?)
			ret.push people[0].talk_take items:items
		end
		return ret.join("\n")  unless ret.empty?
		return "Give who what?".yellow
	end
end



class Test_verb < Verb
	def init
	end
	def action (*args)
		return $area.items.join("\n").to_s
	end
end



VERBS = [

	[[:test],
		Test_verb.new],

	[[:look,:inspect],
		Look.new],

	[[:go,:move,:walk,:run],
		Go.new],

	[[:take,:pick,:pickup,:grab],
		Take.new],

	[[:talk,:communicate],
		Talk.new],

	[[:give,:donate],
		Give.new]

]

