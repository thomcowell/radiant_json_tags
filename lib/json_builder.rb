require 'json'
module JsonTags
	class JsonBuilderError< StandardError; end

	class JsonBuilder
		def initialize
			@context = JsonBuilderContext.new({})
			@current_key = :unknown
		end

		def key(name)
			@context.key name
		end

		def object(name=nil)
			self.new_context({}, name)
		end

		def array(name=nil)
			self.new_context([], name)
		end

		def new_context object, name=nil
			if object.respond_to? :to_json
				context = JsonBuilderContext.new object, @context
				@context.key name unless name.nil?
				@context.push context
				@context = context
			end
		end

		def push(value)
			@context.push value
		end

		def <<(value)
			@context.push value
		end

		def close
			@context = @context.parent
		end

		def to_json
			@context = @context.close
			@context.to_json
		end

	end

	class JsonBuilderContext
		def initialize(current,parent=nil)
			@parent = parent if parent.is_a? JsonBuilderContext
			@current = current
			@current_key = :unknown
		end

		def key(name)
			@current_key = name.to_sym
		end

		def push(value)
			if @current.is_a? Array
				@current << value
			elsif @current_key != :unknown
				if @current.is_a? Hash
					@current[ @current_key ] = value
				else
					@current[ @current_key ] = value
					@current_key = :unknown
				end
			end
		end

		def parent
			@parent || self
		end

		def close
			return self if @parent.nil?
			parent = @parent
			current = self
			while parent != current do
				current = parent
				parent = parent.parent
			end
			current
		end

		def to_json(*args)
			@current.to_json
		end
	end
end