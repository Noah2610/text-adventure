
require "colorize"

# main menu
#require_relative "./src/menu"

require "io/console"
require "encrypt"
#require "awesome_print"
require "byebug"

# game scripts
require_relative "./text/global_text"
require_relative "./src/instance"
require_relative "./src/functions"
require_relative "./src/area"
require_relative "./src/item"
require_relative "./src/verb"
require_relative "./src/keyword"
require_relative "./src/person"
require_relative "./src/area_object"
require_relative "./src/init_instance"
#require_relative "./event"

#$default_savefile = "save0"
$encrypt_password = File.read("./src/.password").strip

$ENV = :development  unless (defined?($ENV))

$savedir = "./saves/"  unless (defined?($savedir))


class Game

	def initialize
		$interaction_state = :normal
		$talking_to = false
		$inventory = []
		add_item :inventory
		#add_item :test_item
		#add_item :apple
		#add_item :foo
		#add_item :bar
	end

	def update
		#puts "Current Area: #{$area.name} (#{$area.to_sym.to_s})"
		puts
		print ">"  if $interaction_state == :talk
		print "> "
		input = get_input

		case ( $interaction_state )
		when :normal
			process_normal input

		when :talk
			process_talk input
		end
	end

	def accept_input? (keyword,input)
		(keyword.to_s.index(input) == 0) && (input.length > 2 || input.length == keyword.length)
	end

	def input_check_verb (word,return_bool=false)
		VERBS.each do |vrow|
			vrow[0].each do |v|
				#return vrow[1]  if (string.include?(v.to_s.gsub("_"," ")))
				if (v.to_s.gsub("_"," ") == word)
					return true  if return_bool
					return vrow[1]
				end
			end
		end
		return false
	end

	def input_check_item (word)
		$inventory.each do |irow|
			irow[0].each do |i|
				return irow[1]  if (accept_input?(i,word))
			end
		end
		$area.items.each do |aitems|
			ITEMS.each do |row|
				if (row[0][0] == aitems)
					row[0].each do |item|
						return row[1].new  if (accept_input?(item,word))
					end
				end
			end
		end
		$area.area_objects.each do |aobjsym|
			find_areaObject(aobjsym).items.each do |item|
				return find_item item  if (accept_input?(item,word))
			end  if (find_areaObject(aobjsym).is_open)
		end
		return false
	end

	def input_check_area (word)
		Array.new.concat($area.neighbors,$area.to_sym(:all)).each do |area|
			AREAS.each do |arow|
				if (area == arow[0][0])
					arow[0].each do |a|
						return arow[1]  if (accept_input?(a,word))
					end
				end
			end
		end
		return false
	end

	def input_check_person (word)
		$area.people.each do |person|
			PEOPLE.each do |prow|
				if (person == prow[0][0])
					prow[0].each do |p|
						return prow[1]  if (accept_input?(p,word))
					end
				end
			end
		end
		return false
	end

	def input_check_areaObject (word)
		$area.area_objects.each do |aobj|
			AREA_OBJECTS.each do |aorow|
				if (aobj == aorow[0][0])
					aorow[0].each do |ao|
						return aorow[1]  if (accept_input?(ao,word))
					end
				end
			end
		end
		return false
	end

	def input_check_area_event (word)
		$area.events.each do |erow|
			erow.each do |event|
				return erow[0]  if (accept_input?(event,word))
			end
		end
		return false
	end

	def input_check_instance (word)
		item = input_check_item(word)
		return item  if item
		area = input_check_area(word)
		return area  if area
		person = input_check_person(word)
		return person  if person
		areaObject = input_check_areaObject(word)
		return areaObject  if areaObject
		return false
	end

	def input_include? (input,instance)
		instance.each do |row|
			row[0].each do |area|
				if (input.include? area.to_s.gsub("_"," "))
					return row[1]  unless row[1].class == Class
					return row[1].new
				end
			end
		end
		return false
	end

=begin  catch-throw (to break out of multiple nested loops)
	catch (:some_symbol) do
		...
		throw :some_symbol
		...
	end
=end

	def process_normal (input)
		input_verb     = false
		#input_item     = false
		#input_item2    = false
		#input_area     = false
		#input_area_sym = false
		#input_person   = false
		#input_objectArea = false
		input_area_event = false
		string = ""
		params = {items:[],areas:[],people:[],areaObjects:[],misc:{}}

		# check for include s
			# check items
			#input_item = input_include?(input, Array.new.concat($inventory,$area.items))
			input_item = input_include?(input, $inventory)
			params[:items].push input_item     if input_item
			# check areas
			#input_area = input_include?(input, Array.new.concat($area.neighbors,$area))
			#params[:areas].push input_area     if input_area
			# check person
			#input_person = input_include?(input, PEOPLE)
			#params[:people].push input_person  if input_person
			
			# check verb
			#input_verb = input_check_verb input.join(" ")  #unless input_verb

		input.each do |word|
			input_verb = input_check_verb word              unless input_verb
			input_item = input_check_item word
			input_area = input_check_area word
			# check area event(s)
			input_area_event = input_check_area_event word  unless input_area_event
			input_person = input_check_person word
			input_areaObject = input_check_areaObject word

			params[:items].push input_item              if input_item
			params[:areas].push input_area              if input_area
			params[:people].push input_person           if input_person
			params[:areaObjects].push input_areaObject  if input_areaObject

			unless (input_check_verb(word).class == input_verb.class)
				if (string == "")
					string = word
				else
					string += " #{word}"
				end
			end

		end

		params[:items].uniq!
		params[:areas].uniq!
		params[:people].uniq!
		params[:areaObjects].uniq!
		params.each_value do |arr|
			arr.each do |inst|
				inst.get_text
			end
		end

		if (input_area_event)
			output $area.method(input_area_event).call
		elsif (input_verb)
			input_verb.keywords.each do |kwrow|
				kwrow[0].each do |kw|
					if (input.include? kw.to_s)
						if (kwrow[1])
							kw_index = input.index(kw.to_s)
							kw_val_index = kw_index + 1  if (input[kw_index + 1])
							#kw_val = is_instance_sym?(input[kw_val_index].to_sym)
							if (kw_val_index)
								kw_val = input_check_instance(input[kw_val_index])
							else
								kw_val = false
							end

							kw_val = false  if (kw_val != false && kw_val.is_item? && !has_item?(kw_val.to_sym))
							params[:misc][:keywords] = { kwrow[0][0] => kw_val }
							#Array.new.concat(params[:items],params[:areas],params[:people],params[:areaObjects]).each do |i|
								#params[:items].delete
							#end
							if (kw_val != false)
								params[:items].each_with_index do |item,index|
									params[:items].delete_at index  if (item.to_sym == kw_val.to_sym)
								end
								params[:areas].each_with_index do |area,index|
									params[:areas].delete_at index  if (area.to_sym == kw_val.to_sym)
								end
								params[:people].each_with_index do |person,index|
									params[:people].delete_at index  if (person.to_sym == kw_val.to_sym)
								end
								params[:areaObjects].each_with_index do |areaObject,index|
									params[:areaObjects].delete_at index  if (areaObject.to_sym == kw_val.to_sym)
								end
							end

						else

							params[:misc][:keywords] = { kwrow[0][0] => true }
						end
					end
				end


			end

			if (input_verb.accept_string && string != "")
				params[:misc][:string] = string
			end

			output input_verb.action(params)
		end

		if (!params[:items].empty? || !params[:areas].empty? || !params[:people].empty? || !params[:areaObjects].empty?) && (!input_verb)
			# look at Person if only person is given
			output Look.new.action(params)
		end

	end


	def process_talk (input)
		params = {items:[],areas:[],people:[],areaObjects:[]}
		method = false

		KEYWORDS_TALK_PHRASES.each do |phrases|
			phrases[0].each do |phrase|
				if (input.join(" ").include? phrase)
					method = phrases[1]
				end
			end
		end

		input.each do |word|

			# check method
			catch (:big_break) do
				KEYWORDS_TALK.each do |row|
					row.each do |kw|
						if (convert_symbol(kw) == word)
							method = row[0]
							throw :big_break
						end
					end
				end
			end
			# check method - person
			catch (:big_break) do
				$talking_to.keywords.each do |row|
					row.each do |kw|
						if (convert_symbol(kw) == word)
							method = row[0]
							throw :big_break
						end
					end
				end
			end

			input_item   = input_check_item word
			params[:items].push input_item              if input_item
			input_area   = input_check_area word
			params[:areas].push input_area              if input_area
			input_person = input_check_person word
			params[:people].push input_person           if input_person
			input_areaObject = input_check_areaObject word
			params[:areaObjects].push input_areaObject  if input_areaObject

		end  unless method

		#puts $talking_to.method("talk_" + method.to_s).call(params)  if method
		output $talking_to.talk(method,params)  if method

	end
end


game = Game.new
if ($ENV == :development || $ENV == :production)
	if (!$current_savefile)
		output Area.goto!(:truck)
		#output Area.goto!(:spaceship_abduct)
		$current_savefile = gen_new_savefile
	else
		output load_game($current_savefile)
	end

	game_running = true
else
	Area.goto! :starting_area
	game_running = false
end

while ( game_running )
	game.update
end

puts "GAME EXITED NATURALLY".bold.red

