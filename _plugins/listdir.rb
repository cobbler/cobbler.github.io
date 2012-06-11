#usage:
#{% listdir directory:images filter:*.jpg sort:descending spacesep:_ %}

require 'pathname'

module Jekyll
    class ListDirectoryTag < Liquid::Tag

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}

            @attributes['directory'] = '';
            @attributes['filter']    = '*';
            @attributes['sort']      = 'ascending';
            @attributes['spacesep']  = '_';

            # Parse parameters
            if markup =~ Syntax
                markup.scan(Liquid::TagAttributes) do |key, value|
                    @attributes[key] = value
                end
            else
                raise SyntaxError.new("Bad options given to 'listdir' plugin.")
            end
            super
        end

        def do_dir(curdir)
            flist = Dir.glob(File.join(curdir, @attributes['filter']))

            if @attributes['sort'].casecmp( "descending" ) == 0
                # Find files and sort them reverse-lexically. This means
                # that files whose names begin with YYYYMMDD are sorted newest first.
                flist.sort! {|x,y| y <=> x }
            else
                # sort normally in ascending order
                flist.sort!
            end

            html = "<ul>"
            flist.each do |item|
                if item == File.join(curdir,"index.md")
                    next
                end

                if FileTest.directory?(item)
                    html = html + do_dir(item)
                else
                    dir = File.dirname(item).gsub(@attributes['directory'],'').gsub('/','.')
                    dir.slice!(0)
                    lentry = dir + "." + File.basename(item,".*").gsub(@attributes['spacesep'],' ')
                    aentry = File.join(curdir,File.basename(item,".*")+".html")
                    html = html + "<li><a href=\"/#{aentry}\">" + lentry + "</a></li>"
                end
            end
            html = html + "</ul>"
        end

        def render(context)
            context.registers[:listdir] ||= Hash.new(0)
            do_dir(@attributes['directory'])
        end
    end
end

Liquid::Template.register_tag('listdir', Jekyll::ListDirectoryTag)
