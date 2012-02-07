require 'json'

class JsonTagExtensionError < StandardError; end

class JsonTagsExtension < Radiant::Extension
  version "0.1.0"
  description "Json output tag library"
  url "http://eightsquarestudio.com/blog/2010/06/05/radiant-json-tags"

  def activate
    Page.send :include, JsonTags
  end
end