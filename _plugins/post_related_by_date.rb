module Jekyll
  class RelatedPostsByDateTag < Liquid::Tag
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

      posts = context.registers[:site].posts
      posts.sort!
      matching_posts = []
      posts.each do |post|
        if post.date.year == thispage.date.year and post.date.month == thispage.date.month
          matching_posts << post
        end
      end

      output =  "<div class='posts related_by_date'>"
      output += "<h4 class='header'>#{Date::MONTHNAMES[thispage.date.month]}, #{thispage.date.year}</h4>"
      matching_posts.reverse.each do |p|
        output += "<div class='post'>"
        if thispage.url == p.url
          output += "<div class='content current'>#{p.data["title"]}</div>"
        else
          output += "<div class='content current'><a href='#{p.url}'>#{p.data["title"]}</a></div>"
        end
        output += "<div class='author'><i>Posted on #{p.date.strftime("%B %d, %Y")}</i></div>"
        output += "</div>"
        #output += "<hr />"
      end
      output += '</div>'
      return output
    end

  end
end

Liquid::Template.register_tag('related_posts_by_date', Jekyll::RelatedPostsByDateTag)
