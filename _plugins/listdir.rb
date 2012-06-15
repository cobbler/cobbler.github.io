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

        def read_dir(curdir)
            this_tree = {}
            this_tree = {}
            this_tree['path'] = curdir
            this_tree['files'] = []
            this_tree['children'] = {}

            flist = Dir.glob(File.join(curdir, @attributes['filter']))
            flist.each do |item|
                (path,name) = File.split(item)
                if FileTest.directory?(item)
                    this_tree['children'][item] = read_dir(item)
                else
                    if name != "index.md"
                        this_tree['files'] << item
                    end
                end
            end

            this_tree
        end

        def print_dir(tree)
            html = '<ul>'

            #print "DEBUG: curdir = #{tree['path']}\n"

            keys = tree['children'].keys()
            keys.sort!

            tree['files'].sort!
            tree['files'].each do |entry|
                (path,name) = File.split(entry)
                (subset,name) = name.split("_-_",2)
                html += "<li>#{entry}</li>"
                if keys.index(subset) != nil
                    html += print_dir(tree['children'][subset])
                end
            end
            html += '</ul>'
        end

        def render(context)
            context.registers[:listdir] ||= Hash.new(0)
            print_dir(read_dir(@attributes['directory']))
        end
    end
end

Liquid::Template.register_tag('listdir', Jekyll::ListDirectoryTag)
