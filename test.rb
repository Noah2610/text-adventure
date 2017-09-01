
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
		@items.each do |instance|
			instance.get_text
			assert_equal true, instance.is_item?, instance.name
			if (instance.in_inv?)
				assert_equal true, instance.in_inv?, "item should be in inventory"
				if (instance.to_sym == :inventory)
					if ($inventory.length == 1 && $inventory[0][0][0] == :inventory)
						assert_equal $text_global[:inventory_no_items], instance.look, instance.name
					end
				else
					assert_equal "#{instance.name}\n#{instance.desc.italic}", instance.look, instance.name
				end
			elsif (instance.to_sym != :inventory)
				assert_equal "#{instance.desc_passive.italic}", instance.look, instance.name
			end
		end

		@areas.each do |instance|
			instance.get_text
			assert_equal true, instance.is_area?, instance.name
			if ($area.to_sym == instance.to_sym)
				assert_equal "#{instance.name}\n#{instance.desc.italic}", instance.look, instance.name
			else
				assert_equal instance.desc_passive.italic, instance.look, instance.name
			end
		end

		@people.each do |instance|
			instance.get_text
			assert_equal true, instance.is_person?, instance.name
			if ($interaction_state == :normal)
				if (instance.have_talked)
					assert_equal "#{instance.name}\n#{instance.desc_passive.italic}", instance.look, instance.name
				else
					assert_equal instance.desc_passive.italic, instance.look, instance.name
				end
			end
		end

		@area_objects.each do |instance|
			instance.get_text
			assert_equal true, instance.is_areaObject?, instance.name
			assert_equal true, instance.look.include?(instance.name)
			assert_equal true, instance.look.include?(instance.desc.italic)
		end
	end

	def test_inventory_manipulation_methods
		# remove :test_item from inventory if exists
		while (has_item? :test_item) do
			rm_item :test_item
		end
		# add item
		inv_count = $inventory.count
		add_item :test_item
		assert_equal inv_count + 1, $inventory.count
		assert_equal true, has_item?(:test_item)
		# remove item
		inv_count = $inventory.count
		rm_item :test_item
		assert_equal inv_count - 1, $inventory.count
		assert_equal false, has_item?(:test_item)
		# clear inventory
		clear_inventory
		assert_equal 0, $inventory.count
	end

	def test_find_instance_method
		# item
		assert_equal :test_item, find_item(:test_item).to_sym
		# area
		assert_equal :starting_area, find_area(:starting_area).to_sym
		# person
		assert_equal :test_person, find_person(:test_person).to_sym
		# area_object
		assert_equal :box, find_areaObject(:box).to_sym
	end

end

