
class Parsley_person < Person
	def init
		@name = "Parsley".green
		#@desc = "NONE"
		#@desc_passive = ""
		@have_talked = true
	end

	def start_talk
		return "He's completely blacked-out,\nI can't do anything to get him to wake up.".italic
	end

end

class Aliens_abduct_person < Person
	def init
	end
	def start_talk
		return @text[:talk]
	end
	def talk (meth=false,params=[])
		return start_talk  unless meth
		leave_talk  if (meth == :bye)
		return "#@name:\n" + gibberish
	end
	def gibberish
		output(@text[:gibberish_thoughts].sample.italic)
		lines = rand(1..4)
		ret = []
		lines.times do
			arr = ("!".."z").to_a.shuffle[0..rand(20..60)]
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
			ret.push arr.join("")
		end
		return ret.map{ |a| next a unless (a[0] == " "); a[0] = ("!".."z").to_a.sample; next a }.join("\n")
	end
end


# guard infront of cell_abduct
class Guard_abduct_person < Person
	def init
		@items = [:keychain_abduct]
		@is_sleeping = false
		@to_save.push :items, :is_sleeping
	end
	def start_talk
		return @text[:talk]  unless @is_sleeping
		return @text[:talk_sleeping]
	end

	def get_keychain  # use stick with guard
		if (@is_sleeping)
			if (@items.include? :keychain_abduct)
				@items.delete :keychain_abduct
				add_item :keychain_abduct
				@desc_passive = @text[:desc_sleeping_nokeychain]
				return @text[:use_stick_asleep]
				# NOTE remove stick maybe?
			else
				return @text[:use_stick_again]
			end
		else
			return @text[:use_stick_awake]
		end
	end

	def fall_asleep
		@is_sleeping = true
		@desc_passive = @text[:desc_sleeping]
	end
end

