
class Glove_compartment_Aobj < Area_object
	def init (args=[])
		@items = [:joint]
		@is_open = false
	end

	def open
		unless (@is_open)
			@is_open = true
			ret = []
			ret.push "I opened the #{@name}."
			@items.each do |item|
				ret.push @item_descs[item]
			end
			return ret.join "\n"
		else
			return "It's already open."
		end
	end

	def close
		if (@is_open)
			@is_open = false
			return "I closed the #{@name}."
		else
			return "It's already closed."
		end
	end

end

class Console_abduct < Area_object
	def init (args=[])
		@turned_on = false
		@cmd_not_found = gibberish
	end
	def use
		return @text[:use_turned_off]  unless (@turned_on)
		ret = []
		#ret.push "§ " + gibberish
		#ret.push @text[:use].italic
		print " § ".bold
		continue_input = true
		user_cmd = []
		while (continue_input)
			STDIN.noecho do |a|
				char = STDIN.getch
				unless (char == "\r")
					user_cmd.push gibberish_char
					print user_cmd.last
				else
					print("\n   " + user_cmd.join("") + ": " + @cmd_not_found.red)
					continue_input = false
				end
			end
		end
		return ret.join("\n")
	end
	def look_additional
		unless (@turned_on)
			return @text[:turned_off]
		else
			return @text[:turned_on]
		end
	end
	
	def turn_on
		@turned_on = true
		return @text[:after_turn_on]
	end
	def turn_off
		@turned_on = false
		return @text[:after_turn_off]
	end

	def gibberish
		arr = ("!"..."0").to_a.concat((":"..."A").to_a).concat(("["..."a").to_a).shuffle[0..rand(10..40)]
		skip = false
		arr.map! do |a|
			if (!skip) && (rand(0...5) == 0)
				skip = true
				next " "
			else
				skip = false
				skip = true  if (a == " ")
				next a
			end
		end
		return arr.join("")
	end
	def gibberish_char
		return (" "..."0").to_a.concat((":"..."A").to_a).concat(("["..."a").to_a).sample
	end

end

