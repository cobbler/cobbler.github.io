# This plugin creates links based on the title and optionally
# other metadata in the FrontMatter YAML. The first match will
# be returned, thus it is possible to specify a comma-separated list
# of other metadata that will be used to match the page for the
# instances where multiple pages may have the same title
#
# Usage:
# {% linkup title:"title goes here" <extrameta:...> %}

module Jekyll
    # Add accessor for directory
    class Page
        attr_reader :dir
    end

    class LinkupTag < Liquid::Tag

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}
            @attributes['title'] = '';
	    @attributes['extrameta'] = '';
            @attributes['alt'] = '';

            # Parse parameters
            if markup =~ Syntax
                markup.scan(Liquid::TagAttributes) do |key, value|
                    @attributes[key] = value.strip
                end
            else
                raise SyntaxError.new("Bad options given to 'linkup' plugin.")
            end

            if @attributes['title'] == ''
                raise SyntaxError.new("You must specify a title when using the 'linkup' plugin.")
            end

            # remove quotes from the title parameter
            quotedata = /^\"(.*)\"$/.match(@attributes['title'])
            if quotedata
                @attributes['title'] = quotedata[1]
            end

            # remove quotes from the alt parameter
            quotedata = /^\"(.*)\"$/.match(@attributes['alt'])
            if quotedata
                @attributes['alt'] = quotedata[1]
            end

            @attributes['extrameta'] = @attributes['extrameta'].split(',')

            super
        end

        def render(context)
            context.registers[:linkup] ||= Hash.new(0)
            html = "**UNDEFINED REFERENCE (#{@attributes['title']}, meta=#{@attributes['extrameta'].join(",")})**"
            pages = posts = context.registers[:site].pages
            pages.each do |page|
                if page.data['title'].strip() == @attributes['title']
                    if @attributes['extrameta'].length() > 0 and page.data.has_key?('meta')
                        metatags = page.data['meta'].split(',')
                        shared = @attributes['extrameta'] & metatags
                        if shared.length() == 0
                            next
                        end
                    end
                    title = page.data['title'].strip()
                    if @attributes['alt'] != ''
                       title = @attributes['alt'].strip()
                    end
                    html = "<a href=\"#{page.dir}#{page.url}\">#{title}</a>"
                    break
                end
            end
            html
        end
    end
end

Liquid::Template.register_tag('linkup', Jekyll::LinkupTag)
