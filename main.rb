
require "colorize"
#require "awesome_print"

# game scripts
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

output Area.goto!(:truck)
#output Area.goto!(:spaceship_abduct)


class Game

	def initialize
		$interaction_state = :normal
		$talking_to = false
		$inventory = []
		add_item :inventory
		add_item :test_item
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

	def input_check_verb (word)
		VERBS.each do |vrow|
			vrow[0].each do |v|
				return vrow[1]  if (word == v.to_s)
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
			
			

		input.each do |word|
			# check verb
			input_verb = input_check_verb word  unless input_verb

			# check item(s)
			input_item = input_check_item word
			params[:items].push input_item     if input_item
			# IMPORTANT:
			# implement some mechanic to read and properly process 2 (or maybe more) items!

			# check area(s)
			input_area = input_check_area word
			params[:areas].push input_area     if input_area
			# check area event(s)
			input_area_event = input_check_area_event word  unless input_area_event

			# check person(s)
			input_person = input_check_person word
			params[:people].push input_person  if input_person

			# check area_object(s)
			input_areaObject = input_check_areaObject word
			params[:areaObjects].push input_areaObject  if input_areaObject

			#AREAS.each do |arow|
			#arow[0].each do |a|
			#if (accept_input?(a,word))
			#input_area = arow[1]
			#break
			#end
			#end
			#end

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
			input_verb.keywords.each do |kw|
				if (input.include? kw.to_s)
					kw_index = input.index(kw.to_s)
					kw_val_index = kw_index + 1 || false
					#kw_val = is_instance_sym?(input[kw_val_index].to_sym)
					kw_val = is_instance_sym?(input[kw_val_index].to_sym)

					puts kw_val.to_s.red
					kw_val = false  if (find_instance(kw_val).is_item? && !has_item?(kw_val))
					params[:misc][:keywords] = { kw => kw_val }
					#Array.new.concat(params[:items],params[:areas],params[:people],params[:areaObjects]).each do |i|
						#params[:items].delete
					#end
					params[:items].each_with_index do |item,index|
						params[:items].delete_at index  if (item.to_sym == kw_val)
					end
					params[:areas].each_with_index do |area,index|
						params[:areas].delete_at index  if (area.to_sym == kw_val)
					end
					params[:people].each_with_index do |person,index|
						params[:people].delete_at index  if (person.to_sym == kw_val)
					end
					params[:areaObjects].each_with_index do |areaObject,index|
						params[:areaObjects].delete_at index  if (areaObject.to_sym == kw_val)
					end
				end
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
game_running = true

while ( game_running )
	game.update
end

