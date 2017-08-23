
class Parsley_person < Person
	def init
		@name = "Parsley".green
		#@desc = "NONE"
		#@desc_passive = ""
		@have_talked = true
	end

	def start_talk
		#$interaction_state = :normal
		#$talking_to = false
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
		return "#@name:\n" + gibberish
	end
	def gibberish
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

