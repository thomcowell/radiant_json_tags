module JsonTags
  #tags available globally   
  include Radiant::Taggable

  class JsonTagError < StandardError; end
  
  desc %{
    Usage:
    <pre><code><r:escape_json key="keyName">Content / Value Here</r:escape_json></code></pre>
    Escapes the contents inbetween into a json safe format 
    i.e. 'keyName' : 'Content / Value Here'
  }
  tag "escape_json" do |tag|
    if tag.attr["key"]
      result = { tag.attr["key"] => tag.expand || "" }
      result.to_json.gsub(/\{|\}/,"")
    else 
      ""
    end
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags>...requires the use of <r:json_tags:*/> inside to build json object...</r:json_tags></code></pre>
    Escapes the contents inbetween into a json safe format from the content added inside
  }
  tag "json_tags" do |tag| 
    tag.locals.json_tags = {}
    tag.expand
    tag.locals.json_tags.to_json
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:pair key="keyName">Content / Value Here</r:json_tags:key></code></pre>
    Adds key value pairs to the to_json object which is output in a json safe format  
  }
  tag "json_tags:pair" do |tag|
    if tag.attr["key"]
      tag.locals.json_tags[ tag.attr["key"] ] = tag.expand || ""
    end
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:object>...<r:json_tags:pair/>...</r:json_tags:object></code></pre>
    Adds object to json value  
  }
  tag "json_tags:object" do |tag|
    original = tag.locals.json_tags
    tag.locals.json_tags = {}
    tag.expand
    object = tag.locals.json_tags
    tag.locals.json_tags = original
    object
  end
   
  desc %{
    Usage:
    <pre><code><r:json_tags:array>...<r:json_tags:array:item>...</r:json_tags:array></code></pre>
    Adds array to json value  
  }
  tag "json_tags:array" do |tag|
    original = tag.locals.json_tags_array
    tag.locals.json_tags_array = []
    tag.expand
    array = tag.locals.json_tags_array
    tag.locals.json_tags_array = original
    array
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:array:item>Content / Value Here</r:json_tags:array:item></code></pre>
    Adds key value pairs to the to_json object which is output in a json safe format  
  }
  tag "json_tags:array:item" do |tag|    
    tag.locals.json_tags_array << tag.expand
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:null/></code></pre>
    Safe way of adding null json value 
  }
  tag "json_tags:null" do |tag|
    nil
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:true/></code></pre>
    Safe way of adding true json value 
  }
  tag "json_tags:true" do |tag|
    true
  end
     
  desc %{
    Usage:
    <pre><code><r:json_tags:false/></code></pre>
    Safe way of adding false json value 
  }
  tag "json_tags:false" do |tag|
    false
  end
  
  desc %{
    Usage:
    <pre><code><r:json_tags:number>23</r:json_tags:number></code></pre>
    Safe way of adding numbers to json value 
  }
  tag "json_tags:number" do |tag|
    tag.expand.to_f
  end
end