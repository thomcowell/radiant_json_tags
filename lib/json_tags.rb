module JsonTags
  #tags available globally   
  include Radiant::Taggable

  class JsonTagError < StandardError; end

  desc %{
    Usage:
    <pre><code><r:json_tags>...requires the use of <r:json_tags:*/> inside to build json object...</r:json_tags></code></pre>
    Escapes the contents inbetween into a json safe format from the content added inside
  }
  tag "json_tags" do |tag|
    tag.locals.json_tags ||= {}
    tag.expand
    tag.locals.json_tags.to_json if tag.nesting == "content:json_tags"
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:pair key="keyName">Content / Value Here</r:json_tags:pair></code></pre>
    Adds key value pairs to the to_json object which is output in a json safe format
  }
  tag "json_tags:pair" do |tag|
    if tag.attr["key"]
      results = tag.expand
      tag.locals.json_tags[ tag.attr["key"] ] = (@force ? @results : (@results || results || ""))
      @results = nil
      @force = false
    end
    ""
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:object key="keyName">...<r:json_tags:pair/>...</r:json_tags:object></code></pre>
    Adds object to json value, attribute key is optional
  }
  tag "json_tags:object" do |tag|
	  original = tag.locals.json_tags
	  tag.locals.json_tags = {}
	  tag.expand
    if tag.attr["key"]
      original[ tag.attr["key"] ] = tag.locals.json_tags
    else
       @results = tag.locals.json_tags
    end
    tag.locals.json_tags = original
    ""
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:array key="keyName">...<r:json_tags:array:item>...</r:json_tags:array></code></pre>
    Adds array to json value
  }
  tag "json_tags:array" do |tag|
    if tag.attr["key"]
      original = tag.locals.json_tags_array
      tag.locals.json_tags_array = []
      tag.expand
      tag.locals.json_tags[ tag.attr["key"] ] = tag.locals.json_tags_array
      tag.locals.json_tags_array = original
    end
    ""
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:array_item>Content / Value Here</r:json_tags:array_item></code></pre>
    Pushes the value onto the json array, must be nested inside json_tags:array
  }
  tag "json_tags:array_item" do |tag|
    if tag.locals.json_tags_array.is_a? Array
      results = tag.expand
      tag.locals.json_tags_array << (@force ? @results : ( @results || results ))
      @results = nil
      @force = false
    end
    ""
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:null/></code></pre>
    Safe way of adding null json value
  }
  tag "json_tags:null" do |tag|
    @force = true
    @results = nil
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:true/></code></pre>
    Safe way of adding true json value
  }
  tag "json_tags:true" do |tag|
    @force = true
    @results = true
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:false/></code></pre>
    Safe way of adding false json value
  }
  tag "json_tags:false" do |tag|
    @force = true
    @results = false
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:number>23</r:json_tags:number></code></pre>
    Safe way of adding numbers to json value
  }
  tag "json_tags:number" do |tag|
    @force = true
    @results = tag.expand.to_f
  end
end