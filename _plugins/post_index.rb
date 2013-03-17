module Jekyll
  class PostIndexTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end

    def get_current_page(context)
      purl = context.environments.first["page"]["url"]
      context.registers[:site].posts.each do |p|
        if p.url == purl
          return p
        end
      end
      return nil
    end

    def render(context)
      thispage = get_current_page(context)
      maxpages = context.registers[:site].config["paginate"]
      output = ""

      posts = context.registers[:site].posts
      posts.reverse.each_with_index do |post,i|
        if post.url == thispage.url
          index = i/maxpages
          if index == 0
            link = "/posts/"
          else
            link = "/posts/page#{index + 1}/"
          end
          output = "<a href='#{link}'><i class='icon-double-angle-left'></i> go back</a>"
          break
        end
      end

      return output
    end

  end
end

Liquid::Template.register_tag('post_index', Jekyll::PostIndexTag)
