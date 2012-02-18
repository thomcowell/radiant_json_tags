require File.dirname(__FILE__) + "/json_builder"

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
    tag.locals.json_tags ||= JsonBuilder.new
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
      tag.locals.json_tags.key tag.attr["key"]
      content = tag.expand
      tag.locals.json_tags << content unless content.blank?
    end
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:object key="keyName">...<r:json_tags:pair/>...</r:json_tags:object></code></pre>
    Adds object to json value, attribute key is optional
  }
  tag "json_tags:object" do |tag|
	  tag.locals.json_tags.object tag.attr["key"]
	  tag.expand
    tag.locals.json_tags.close
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:array key="keyName">...<r:json_tags:array:item>...</r:json_tags:array></code></pre>
    Adds array to json value
  }
  tag "json_tags:array" do |tag|
    tag.locals.json_tags.array tag.attr["key"]
    tag.expand
    tag.locals.json_tags.close
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:array_item>Content / Value Here</r:json_tags:array_item></code></pre>
    Pushes the value onto the json array, must be nested inside json_tags:array
  }
  tag "json_tags:array_item" do |tag|
    content = tag.expand
    tag.locals.json_tags << content unless content.blank?
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:null/></code></pre>
    Safe way of adding null json value
  }
  tag "json_tags:null" do |tag|
    tag.locals.json_tags << nil
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:true/></code></pre>
    Safe way of adding true json value
  }
  tag "json_tags:true" do |tag|
    tag.locals.json_tags << true
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:false/></code></pre>
    Safe way of adding false json value
  }
  tag "json_tags:false" do |tag|
    tag.locals.json_tags << false
  end

  desc %{
    Usage:
    <pre><code><r:json_tags:number>23</r:json_tags:number></code></pre>
    Safe way of adding numbers to json value
  }
  tag "json_tags:number" do |tag|
    tag.locals.json_tags << tag.expand.to_f
  end
end