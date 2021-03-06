
class Verb
	attr_accessor :keywords, :accept_string

	def initialize
		@default = "I don't understand.".yellow
		@keywords = []
		@accept_string = false
		eval(File.read("./text/verb_text.rb"))
		self.init
	end
	def action (*args)
		"Default Verb action, args: " + args.join(", ")
	end
end



class Save < Verb
	def init
		@accept_string = true
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		unless (misc[:string].nil?)
			return save_game misc[:string]
		else
			return save_game
		end
	end
end

class Load < Verb
	def init
		@accept_string = true
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		unless (misc[:string].nil?)
			return load_game misc[:string]
		else
			return load_game
		end
	end
end

class Savefile < Verb
	# TODO
	# let user change $current_savefile with this verb
	def init
	end
	def action (*params)
		return "Currently using savefile:\n#{$current_savefile.bold}"
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
			if instance.class.method_defined? :open
				ret.push instance.open
			else
				ret.push "I can't open #{instance.name}."
			end
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
		@keywords = [
			#         vvvv keyword accepts instance if set to true
			[[:with], true]
		]
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		return "Use what?".italic  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
		unless (misc[:keywords].nil?)
			if (misc[:keywords][:with])
				Array.new.concat(items,areas,people,areaObjects).each do |instance|
					return instance.use_with(misc[:keywords][:with])
				end
			else
				return "Use with what?".italic
			end
		else

			ret = []
			Array.new.concat(items,areas,people,areaObjects).each do |instance|
				ret.push instance.use
			end
			return ret.join("\n")
=begin
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
=end
		end
	end
end


class Turn < Verb
	def init
		@keywords = [
			[[:on],false],
			[[:off],false]
		]
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		unless (misc[:keywords].nil?)
			if (misc[:keywords][:on])
				return "Turn on what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
				Array.new.concat(items,areas,people,areaObjects).each do |instance|
					ret.push instance.turn_on
				end

			elsif (misc[:keywords][:off])
				return "Turn off what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
				Array.new.concat(items,areas,people,areaObjects).each do |instance|
					ret.push instance.turn_off
				end

			end
		else
			return "Turn what?"  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)
			Array.new.concat(items,areas,people,areaObjects).each do |instance|
				ret.push instance.turn
			end
		end
		return ret.join("\n").italic
	end
end


class Sit < Verb
	def init
		@keywords = [
			[[:floor,:ground], false]
		]
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		ret = []
		unless (misc[:keywords].nil?)
			if (misc[:keywords][:floor])
				ret.push @text[:sit_floor]
			end
		else
			Array.new.concat(items,areas,people,areaObjects).each do |instance|
				ret.push instance.sit
			end
			return "Do I want to sit on the #{"floor".red}?".italic  if (items.empty? && areas.empty? && people.empty? && areaObjects.empty?)

		end
		return ret.join("\n").italic
	end
end


class Unlock < Verb
	def init
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		arr = Array.new.concat(items,areas,people,areaObjects)
		return "Unlock what?"  if arr.empty?
		ret = []
		arr.each do |instance|
			ret.push instance.unlock
		end
		return ret.join("\n")
	end
end

#class Stand_up < Verb
	#def init
	#end
	#def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
	#end
#end



require_relative "./dev/verb"


VERBS = [

	[[:test],
		Test_verb.new],

	[[:save],
		Save.new],
	[[:load],
		Load.new],
	[[:savefile],
		Savefile.new],

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
		Use.new],

	[[:turn],
		Turn.new],

	[[:sit],
		Sit.new],

	[[:unlock],
		Unlock.new]

]

require_relative "./verb_area"

