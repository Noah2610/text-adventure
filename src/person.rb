
class Person < Instance
	attr_accessor :keywords, :have_talked

	def initialize_instance (*args)
		@name = "person_name".red
		@desc_passive = "Default passive Person description."
		@desc = "I am a Person."
		@keywords = []
		@take_items = []
		@have_talked = false
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


require_relative "./dev/person"
require_relative "./game/person"

