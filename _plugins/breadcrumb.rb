# usage:
# {% breadcrumb <directory:dir_name> %}
# 
# This will output a Twitter Bootstrap formatted breadcrumb structure. 
# See http://twitter.github.com/bootstrap/components.html#breadcrumbs
# for more details.
#
# The directory argument specifies a directory name that, when encountered, 
# ends the backtracking of the url up the tree. If directory isn't 
# specified, it will continue moving up to the root of the current pages url.

module Jekyll
    # Add accessor for directory
    # this lets us get the full path to the page
    class Page
        attr_reader :dir
    end

    class BreadCrumbTag < Liquid::Tag

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}
            @attributes['directory'] = '';

            @cache = {}

            # Parse parameters
            if markup =~ Syntax
                markup.scan(Liquid::TagAttributes) do |key, value|
                    @attributes[key] = value
                end
            else
                raise SyntaxError.new("Bad options given to 'breadcrumb' plugin.")
            end

            super
        end

        def find_parent(dir,context)
            if @cache.has_key?(dir)
              puts "DEBUG: cached entry for #{dir} = #{@cache[dir]}"
              return @cache[dir]
            end
            context.environments.first["site"]["pages"].each do |p|
              (pdir,fname) = File.split(p.dir)
              puts "DEBUG: dir = #{dir}, page dir = #{pdir}"
              if pdir == dir
                puts "DEBUG: dir = #{dir}, page match url = #{pdir}/#{fname}"
                @cache[dir] = fname
                return fname
              end
            end
            return "/"
        end

        def render(context)
            context.registers[:breadcrumb] ||= Hash.new(0)

            page = context.environments.first["page"]
            oparts = context.environments.first["page"]["url"].split("/")
            oparts.reverse!

            # search up through the url path to find the first
            # directory that matches the specified attribute.
            # If no attr was specified, this is skipped and the 
            # entire path is used.
            last = oparts.size - 1
            if @attributes['directory'] != "/"
              oparts.each_with_index do |part,index|
                if part == @attributes['directory']
                  last = index
                  break
                end
              end
            end

            # the actual step to cut the url up
            parts = oparts[0..last].reverse

            url_start = oparts[last..-1].reverse.join("/")

            html = '<ul class="breadcrumb">'
            parts.each_with_index do |part,index|
              if part == ""
                next
              end
              url_start += "/#{part}"
              #matches = context.environments.first["site"]["pages"].find_all{|p| url_start == p.url}
              #puts "DEBUG: #{url_start} matches = #{matches}"
              if index == parts.size-1
                html += "<li class=\"active\">#{page['title']}</li>"
              else
                #html += "<li><a href=\"#{url_start + find_parent(url_start,context)}\">#{part}</a> <span class=\"divider\">/</span></li>"
                html += "<li><a href=\"#{url_start}\">#{part}</a> <span class=\"divider\">/</span></li>"
              end
            end
            html += '</ul>'
        end
    end
end

Liquid::Template.register_tag('breadcrumb', Jekyll::BreadCrumbTag)
