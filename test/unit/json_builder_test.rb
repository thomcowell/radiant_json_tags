require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/json_builder'
require "json"

class JsonBuilderTest < Test::Unit::TestCase

	# Called before every test method runs. Can be used
	# to set up fixture information.
	def setup
		@json_builder = JsonTags::JsonBuilder.new
		# Do nothing
	end

	# Called after every test method runs. Can be used to tear
	# down fixture information.

	def teardown
		# Do nothing
	end

	def test_initialize
		it = JsonTags::JsonBuilder.new
		assert_equal "{}", it.to_json
	end

	def test_adding_pair
		@json_builder.key "bob"
		@json_builder << "loblaw"
		assert_equal ({:bob => "loblaw"}.to_json), @json_builder.to_json
	end

	def test_adding_pair_other
		@json_builder.key "bob"
		@json_builder << "loblaw"
		@json_builder.key "ham"
		@json_builder << false
		@json_builder.key "jam"
		@json_builder << true
		@json_builder.key "sam"
		@json_builder << nil
		@json_builder.key "nam"
		@json_builder << 1
		assert_equal ({:bob => "loblaw",:ham => false,:jam => true, :sam => nil,:nam => 1}.to_json), @json_builder.to_json
	end

	def test_adding_array
		@json_builder.array "bob"
		@json_builder << 1
		@json_builder << "2"
		@json_builder << true
		@json_builder << false
		@json_builder << nil
		assert_equal ({:bob => [1,"2",true,false,nil]}.to_json), @json_builder.to_json
	end

	def test_adding_object
		@json_builder.object "bob"
		@json_builder.key "bob"
		@json_builder << "loblaw"
		@json_builder.key "ham"
		@json_builder << false
		@json_builder.key "jam"
		@json_builder << true
		@json_builder.key "sam"
		@json_builder << nil
		@json_builder.key "nam"
		@json_builder << 1
		assert_equal ({:bob => {:bob => "loblaw",:ham => false,:jam => true, :sam => nil,:nam => 1}}.to_json), @json_builder.to_json
	end

	def test_nested_array
		@json_builder.array "bob"
		@json_builder.array
		@json_builder << "2"
		@json_builder << true
		@json_builder.close
		@json_builder.array
		@json_builder << false
		@json_builder << nil
		assert_equal ({:bob => [["2",true],[false,nil]]}.to_json), @json_builder.to_json
	end
end