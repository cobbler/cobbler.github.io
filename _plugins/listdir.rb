#usage:
#{% listdir <directory:dir_name> <filter:*> <spacesep:_> %}
# If directory isn't specified, it will:
#   1) default to the directory the page is in. 
#   2) If the page url starts with X_-_... it will check if there 
#      is a subdirectory with the name X and use that instead.
# 
# The filter can be specified to filter out other files/directories.
# Any file named index.md is skipped no matter what.
#
# The spacesep specifies a character sequence that will be replaced 
# in the file name with a space character (underscore by default).
# This allows you to use filenames with no spaces and avoid ugly URLs.

require 'pathname'

module Jekyll
    class ListDirectoryTag < Liquid::Tag

        include Liquid::StandardFilters
        Syntax = /(#{Liquid::QuotedFragment}+)?/

        def initialize(tag_name, markup, tokens)
            @attributes = {}

            @attributes['directory'] = '.';
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

        def pretty_label(label) 
            (dir,name) = File.split(label)
            dir.gsub!(@attributes['directory'],"")
            dir = dir.split(File::SEPARATOR).join(".")
            if dir[0..0] == "."
                dir = dir[1..-1]
            end
            name = File.basename(name,".*")
            name.gsub!(@attributes['spacesep']," ")
            if dir != ""
                "#{dir}.#{name}"
            else
                name
            end
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
            html = '<ul class="dirtree">'

            keys = tree['children'].keys()
            keys.sort!

            tree['files'].sort!
            tree['files'].each do |entry|
                (path,name) = File.split(entry)
                (subset,rest) = name.split("_-_",2)
                name = File.basename(name,".*")
                link = "/#{path}/#{name}.html"
                html += "<li><a href=\"#{link}\">#{pretty_label(entry)}</a></li>"
                subkey = File.join(tree['path'],subset)
                if keys.index(subkey) != nil
                    html += print_dir(tree['children'][subkey])
                    keys.delete(subkey)
                end
            end
            keys.each do |key|
                html += "<li>#{pretty_label(key)}</li>"
                html += print_dir(tree['children'][key])
            end
            html += '</ul>'
        end

        def render(context)
            context.registers[:listdir] ||= Hash.new(0)

            (dir,name) = File.split(context.environments.first["page"]["url"][1..-1])
            (sub,rest) = name.split("_-_",2)
            if @attributes['directory'] == '.'
                #print "DEBUG: no directory specified, figuring out based on the url #{dir}/#{name}\n"
                if FileTest.directory?(File.join(dir,sub))
                    @attributes['directory'] = File.join(dir,sub)
                else
                    @attributes['directory'] = dir
                end
            end
            #print "DEBUG: directory will be #{@attributes['directory']}\n"
            html = '<div class="toc">'
            html += print_dir(read_dir(@attributes['directory']))
            html += '</div>'
        end
    end
end

Liquid::Template.register_tag('listdir', Jekyll::ListDirectoryTag)
