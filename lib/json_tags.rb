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
end