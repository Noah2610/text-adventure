
class Verb
	attr_accessor :keywords

	def initialize
		@default = "I don't understand.".yellow
		@keywords = []
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

	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		Array.new.concat(items,areas,people,areaObjects).each do |instance|
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

	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		return @default  if (areas.empty? && (!items.empty? || !people.empty?))
		if (!areas.empty?)
			return areas[0].goto!
		else
			ret = "I can go to "
			if ($area.neighbors.length > 1)
				$area.neighbors.each_with_index do |nb,i|
					find_area(nb).get_text
					if (i < $area.neighbors.length - 1)
						#ret += "#{nb.to_s.gsub("_"," ")}, "
						ret += "#{find_area(nb).name}, "
					else
						ret += "and #{find_area(nb).name}."
					end
				end
			elsif ($area.neighbors.length == 1)
				find_area($area.neighbors.first).get_text
				ret += "#{find_area($area.neighbors[0]).name}."
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

	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		return "Now why and how would I take that?"  if (items.empty? && (!areas.empty? || !people.empty?))
		return "Take what?"  if (items.empty? && areaObjects.empty?)
		ret = []
		Array.new.concat(items,areaObjects).each do |instance|
			if (instance.class.superclass == Item)
				if (instance.in_inv?)
					ret.push "I already grabbed #{instance.name}."
				else
					if ($area.items.include? instance.to_sym)
						$area.rm_item_instance instance.to_sym
					else
						$area.area_objects.each do |aobj|
							find_areaObject(aobj).rm_item_instance instance.to_sym  if (find_areaObject(aobj).items.include? instance.to_sym)
						end
					end
					add_item instance.to_sym
					ret.push $inventory.last[1].take.italic
				end
			elsif (instance.class.superclass == Area_object)
				if (instance.class.method_defined? :take)
					ret.push instance.take
				else
					ret.push "There's nothing to take from #{instance.name}."
				end
			end
		end
		return ret.join("\n").italic
	end
end


class Talk < Verb
	def init
	end

	#def action (person=false,opts=false)
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		if (!people.empty? && people[0].is_person?)
			$interaction_state = :talk
			$talking_to = people[0]
			return people[0].talk
		end
		return "I don't think that would be a very interesting conversation.".italic  unless (items.empty? && areas.empty?)
		return "To who do I want to talk?".italic
	end
end


class Give < Verb
	def init
	end

	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		if (!items.empty? && !people.empty?)
			ret.push people[0].talk_take items:items
		end
		return ret.join("\n")  unless ret.empty?
		return "Give who what?".italic
	end
end


class Open < Verb
	def init
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		Array.new.concat(items,areaObjects).each do |instance|
			ret.push instance.open  if instance.class.method_defined? :open
		end
		return ret.join("\n").italic  unless ret.empty?
		return "Open what?".italic
	end
end


class Close < Verb
	def init
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		Array.new.concat(items,areaObjects).each do |instance|
			ret.push instance.close  if instance.class.method_defined? :close
		end
		return ret.join("\n").italic  unless ret.empty?
		return "Close what?".italic
	end
end


class Use < Verb
	def init
<<<<<<< Updated upstream
		@keywords = [:with]
=======
		@keywords = [
			#         vvvv keyword accepts instance if set to true
			[[:with], true]
		]
>>>>>>> Stashed changes
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		return "Use what?".italic  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
		if (misc[:keywords] != nil)
			if (misc[:keywords][:with])
				Array.new.concat(items,areas,people,areaObjects).each do |instance|
					return instance.use_with(misc[:keywords][:with])
				end
			else
				return "Use with what?".italic
			end
		else
			ret = []
			if (items.any?)
				items.each do |item|
					use_ret = item.use
					return use_ret  if (use_ret)
				end
			end
			arr = Array.new.concat(items,areas,people,areaObjects)
			return "I can't use #{arr.first.name}.".italic  if (arr.count == 1)
			ret = ["I can't use"]
			arr.each_with_index do |instance,i|
				ret.push "#{instance.name},"  unless (i == arr.count - 1)
			end
			ret.push "or #{arr.last.name}."
			return ret.join(" ").italic
		end
	end
end


class Turn < Verb
	def init
		@keywords = [:on,:off]
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		if (misc[:keywords] != nil)
			if (misc[:keywords][:on])
				return "Turn on what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)


			elsif (misc[:keywords][:off])
<<<<<<< Updated upstream
=======
				return "Turn off what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)

>>>>>>> Stashed changes
			end
		else
			return "Turn what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
			return "You can't actually turn anything at the moment."
		end
	end
end


require_relative "./dev/verb"


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
		Give.new],

	[[:open],
		Open.new],

	[[:close],
		Close.new],

	[[:use,:interact],
		Use.new]

]

