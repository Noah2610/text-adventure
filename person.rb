
class Person < Instance
	attr_accessor :name

	def initialize
		@name = "person_name".red
		@desc = "Default Person description."
		@descSelf = "I am a Person."
		self.init
	end
	def talk
		"Started talking to #{@name} now. Default talk output."
	end

	# all verbs for conversation:
	def talk_hello (params=[])
		"Hello! Default #{"hello".red} output."
	end
	def talk_bye (params=[])
		$interaction_state = :normal
		$talking_to = false
		"Goodbye! Default #{"bye".red} output."
	end
	def talk_bye_good (params=[])
		$interaction_state = :normal
		$talking_to = false
		"Goodbye fine sir! Default #{"bye_good".red} output."
	end
	def talk_bye_bad (params=[])
		$interaction_state = :normal
		$talking_to = false
		"Hope I never see you again! Default #{"bye_bad".red} output."
	end
	def talk_tell (params=[])
		"Default #{"tell".red} output."
	end
	def talk_about (params=[])
		"I am the default! Default #{"about".red} output."
	end
	def talk_doing (params=[])
		"Default #{"doing".red} output."
	end
	def talk_take (params=[])
		"Default #{"take".red} output."
	end
	def talk_about (params=[])
		"I am a test Person. Only here for testing purposes during development.\nDefault #{"about".red} output."
	end
	def talk_about (params=[])
		"I'm doing great! Default #{"doing".red} output."
	end
end



class Test_person < Person
	def init
		@name = "Test Person".red
		@desc = "It looks like a person used for development testing."
		@descSelf = "I am only here for testing purposes"
		@take_items = [:test_item]
	end

	def talk
		ret = "#{@name}: "
		ret += "We are talking now!"
		return ret
	end

	def talk_take (params)
		ret = []
		response = []
		params[:items].each_with_index do |item,i|
			if (has_item? item)
				if (@take_items.include? item.to_sym)
					@take_items.delete item.to_sym
					rm_item item
					ret.push "I gave the #{params[:items][i].name} to #{@name}."
					response.push "Thanks for that #{item.name}. I really needed that."
				else
					response.push "I don't know why I would need #{item.name}."
				end
			else
				ret.push "I don't have #{item.name}."
			end
		end
		ret = "#{ret.join("\n")}\n#{@name}: #{response.join("\n")}"
		return ret
	end

end


PEOPLE = [
	[[:test_person,:person], Test_person.new]
]

