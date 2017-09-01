
require "minitest/autorun"

$ENV = :test

require_relative "./main"


class Test_instance < Minitest::Test
	def setup
		@items = []
		ITEMS.each do |row|
			@items.push row[1].new
		end
		@areas = []
		AREAS.each do |row|
			@areas.push row[1].dup
		end
		@people = []
		PEOPLE.each do |row|
			@people.push row[1].dup
		end
		@area_objects = []
		AREA_OBJECTS.each do |row|
			@area_objects.push row[1].dup
		end
		@all_instances = Array.new.concat(@items,@areas,@people,@area_objects)
	end

	def test_proper_inherits
		@items.each do |instance|
			assert_equal Item, instance.class.superclass, instance.name
			assert_equal Instance, instance.class.superclass.superclass, instance.name
		end
		@areas.each do |instance|
			assert_equal Area, instance.class.superclass, instance.name
			assert_equal Instance, instance.class.superclass.superclass, instance.name
		end
		@people.each do |instance|
			assert_equal Person, instance.class.superclass, instance.name
			assert_equal Instance, instance.class.superclass.superclass, instance.name
		end
		@area_objects.each do |instance|
			assert_equal Area_object, instance.class.superclass, instance.name
			assert_equal Instance, instance.class.superclass.superclass, instance.name
		end
	end

	def test_look_output
		@all_instances.each do |instance|
			instance.get_text
			if (instance.is_item? && instance.in_inv?)
				if (instance.to_sym == :inventory)
					if ($inventory.length == 1 && $inventory[0][0][0] == :inventory)
						assert_equal $text_global[:inventory_no_items], instance.look, instance.name
					end
				else
					#assert_match /^#{instance.name}\n#{instance.desc}/, instance.look, instance.name
					assert_equal "#{instance.name}\n#{instance.desc.italic}.", instance.look, instance.name
				end
			elsif (instance.is_item?)
				#assert_match /^#{instance.name}\n#{instance.desc_passive}/, instance.look, instance.name
				assert_equal "#{instance.desc_passive.italic}", instance.look, instance.name
			end
		end
	end

end

