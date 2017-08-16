
class Person < Instance
	attr_accessor :keywords

	def initialize_instance (*args)
		@name = "person_name".red
		@desc_passive = "Default passive Person description."
		@desc = "I am a Person."
		@keywords = []
		@take_items = []
		self.init
	end
	def talk
		"Started talking to #{@name} now. Default talk output."
	end
	def leave
		$interaction_state = :normal
		$talking_to = false
	end

	# all verbs for conversation:
	def talk_hello (params=[])
		return "Hello! Default #{"hello".red} output."
	end
	def talk_bye (params=[])
		leave
		"Goodbye! Default #{"bye".red} output."
	end
	def talk_bye_good (params=[])
		leave
		$interaction_state = :normal
		$talking_to = false
		"Goodbye fine sir! Default #{"bye_good".red} output."
	end
	def talk_bye_bad (params=[])
		leave
		$interaction_state = :normal
		$talking_to = false
		"Hope I never see you again! Default #{"bye_bad".red} output."
	end
	def talk_tell (params=false)
		"Default #{"tell".red} output."
	end
	def talk_doing (params=false)
		"Default #{"doing".red} output."
	end
	def talk_take (params=false)
		return "You want to give me something?"  if params[:items].empty?
		ret = []
		response = []
		params[:items].each_with_index do |item,i|
			if (item.in_inv?)
				if (@take_items.include? item.to_sym)
					@take_items.delete item.to_sym
					rm_item(item.to_sym)
					ret.push "I gave the #{params[:items][i].name} to #{@name}.".italic
					response.push "Thanks for that #{item.name}. I needed that."
				else
					response.push "I don't know why I would need #{item.name}."
				end
			else
				ret.push "I don't have #{item.name}.".italic
			end
		end
		ret = "#{ret.join("\n")}\n#{@name}: #{response.join("\n")}"
		return ret
		
	end
	def talk_about (params=false)
		"#@desc"
	end
end



class Test_person < Person
	def init
		@name = "Test Person".red
		@desc_passive = "It looks like a person used for development testing."
		@desc = "I am only here for testing purposes"
		@take_items = [:test_item]
	end

	def talk
		ret = "#{@name}: "
		ret += "We are talking now!"
		return ret
	end

	#def talk_take (params=false)
		#ret = []
		#response = []
		#params[:items].each_with_index do |item,i|
			#if (item.in_inv?)
				#if (@take_items.include? item.to_sym)
					#@take_items.delete item.to_sym
					#remove_item(item.to_sym)
					#ret.push "I gave the #{params[:items][i].name} to #{@name}."
					#response.push "Thanks for that #{item.name}. I really needed that."
				#else
					#response.push "I don't know why I would need #{item.name}."
				#end
			#else
				#ret.push "I don't have #{item.name}."
			#end
		#end
		#ret = "#{ret.join("\n")}\n#{@name}: #{response.join("\n")}"
		#return ret
	#end

end

class Crazy_person < Person
	def init
		@name = "Crazy Dude".green
		@talked = false
		@keywords = [
			[:them,:they],
			[:mansion,:house],
			[:no_problem]
		]
		@desc_passive == "It looks like something that could have been human once.\n"
										 "It barely has any hair and it's body appears very disformed.\n"
										 "Hopefully it's just some harmless #{"crazy person".green}."

		@desc = "I Am ThE OWNerr oF ThIS #{"mANSiON".red}\nYOU Got a #{"proBlEM".yellow} wiHT dat?"
	end

	def convert_output (output)
		return output.split("").map { |let| next let.upcase  if (rand(2) == 0); next let }
													 .join("")
	end

	def talk
		unless (@talked)
			@talked = true
			return "It doesn't seem to have noticed me yet.".italic
		else
			return convert_output("what do you want?")
		end
	end
	def talk_hello (params=false)
		return convert_output("are you one of ") + "THEM".blue + "?"
	end
	def talk_bye (params=false)
		leave
		return convert_output("you know you cannot escape ") + "MY HOUSE".red + "."
	end
	def talk_them (params=false)
		return convert_output("the people in white sheeets who try and make me think that i'm ") + "CRAZY".green + convert_output(" and seeing things.")
	end
	def talk_mansion (params=false)
		return convert_output("this is ") + "MY MANSION".red + convert_output(" i've beeen here for a long time.\nmaybe too long.")
	end
end


PEOPLE = [
	[[:test_person,:person], Test_person.new],
	[[:crazy_person,:human_like_figure,:figure], Crazy_person.new]
]

