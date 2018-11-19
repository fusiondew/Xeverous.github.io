module Jekyll
  class DebugInfoTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
	  @tokens = tokens
    end
	
	# Lookup allows access to the page/post variables through the tag context
	def lookup(context, name)
	  lookup = context
	  name.split(".").each { |value| lookup = lookup[value] }
	  lookup
	end

    def render(context)
	  output = "<pre>"
	  output += "tag text: #{@text}\n"
      output += "page time: #{Time.now}\n"
	  #output += "page tokens: #{@tokens}\n"
	  baseurl = "#{lookup(context, 'site.baseurl')}"
	  output += "page base ulr: #{baseurl}\n"
	  title = "#{lookup(context, 'page.title')}"
	  output += "page title: #{title}\n"
	  path = "#{lookup(context, 'page.path')}"
	  output += "page path: #{path}\n"
	  output += "</pre>"
	  return output
    end
  end
end

Liquid::Template.register_tag('debug_info', Jekyll::DebugInfoTag)
