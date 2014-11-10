module Jekyll
  class CategorizeLoader < Generator
    safe true

    def generate(site)
      @newest_post = site.posts.sort { |a, b| b <=> a }[0..300]

      featured = select 'featured'
      printed = select 'printed'
      opinion = select 'opinion'
      interviews = select 'interviews'
      services = select 'services'
      miscelaneous = select 'miscelaneous'
      carousel = @newest_post.slice!(0,3) # the first third posts goes on carousel
      recent = @newest_post.slice!(0,2) # the two  post goes on recent
      featured_news = @newest_post.slice!(0,6)

      services_values = ['our-health', 'our-rights', 'reader-board']
      our_health, our_rights, reader_board = search('service', services_values, services)

      miscelaneous_values = ['recipe', 'cultural-agenda', 'horoscope']
      recipe, cultural_agenda, horoscope = search('miscelaneous', miscelaneous_values, miscelaneous)

      site.config['featured'] = featured.first
      site.config['printed'] = printed.first
      site.config['opinion'] = opinion
      site.config['carousel'] = carousel
      site.config['recent'] = recent
      site.config['interviews'] = interviews
      site.config['featured_news'] = featured_news
      site.config['miscelaneous'] = miscelaneous
      site.config['our_health'] = our_health
      site.config['our_rights'] = our_rights
      site.config['reader_board'] = reader_board
      site.config['recipe'] = recipe
      site.config['cultural_agenda'] = cultural_agenda
      site.config['horoscope'] = horoscope
    end

    def select value, field = 'section'
      result = @newest_post.select do |post|
        post.data[field] == value
      end
      @newest_post = @newest_post - result
      result
    end

    def search key, values, collection
      values.map do |value|
        collection.find do |post|
          post.data[key] == value
        end
      end
    end
  end
end
