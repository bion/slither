require_relative './entity_builder'

class IdentifyEntity
  class TwitterBuilder < EntityBuilder
    ENTITY_DOMAINS = %w[
      twitter.com
      www.twitter.com
    ]

    def self.valid_domains
      ENTITY_DOMAINS
    end

    def find_or_build_entity
      return entity if entity.persisted?

      username = get_username

      return nil unless username

      entity.name = username
      entity.kind = 'twitter-user'

      entity
    end

    private

    def get_username
      uri.path.split("/")[1].downcase
    end
  end
end
