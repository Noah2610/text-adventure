
class Parsley_person < Person
	def init
		@name = "Parsley".green
		#@desc = "NONE"
		#@desc_passive = ""
		@have_talked = true
	end

	def talk
		$interaction_state = :normal
		$talking_to = false
		return "He's completely blacked-out,\nI can't do anything to get him to wake up.".italic
	end

end

class Aliens_abduct_person < Person
	def init
	end

	def talk
		return @text[:talk]
	end
end

