require_relative './entity_builder'

class IdentifyEntity
  class YoutubeBuilder < EntityBuilder
    ENTITY_DOMAINS = %w[
      youtube.com
      youtu.be
      www.youtube.com
      www.youtu.be
    ]

    YOUTUBE_USER_LINK_REGEX = /.+\/user\/(.+)$/

    def self.valid_domains
      ENTITY_DOMAINS
    end

    def find_or_build_entity
      return entity if entity.persisted?

      username = get_entity_user

      return nil unless username

      entity.name = username
      entity.kind = 'youtube-user'

      entity
    end

    private

    def get_entity_user
      path = uri.path

      if path.start_with? '/channel'
        user = get_username_from_channel_page(agent.get(uri.to_s))
      elsif path.start_with? '/watch'
        user = get_username_from_video_page(agent.get(uri.to_s))
      elsif path.start_with? '/user'
        user = uri.to_s.match(YOUTUBE_USER_LINK_REGEX).captures.first
      else
        return nil
      end

      user
    end

    def get_username_from_video_page(page)
      page
        .css('span[itemprop="author"] link')
        .first
        .attribute('href')
        .value
        .match(YOUTUBE_USER_LINK_REGEX)
        .captures
        .first
    end

    def get_username_from_channel_page(page)
      page
        .css('link[rel="canonical"]')
        .first
        .attribute('href')
        .value
        .match(YOUTUBE_USER_LINK_REGEX)
        .captures
        .first
    end
  end
end
