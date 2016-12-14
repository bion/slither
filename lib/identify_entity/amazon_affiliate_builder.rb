require_relative './entity_builder'

class IdentifyEntity
  class AmazonAffiliateBuilder < EntityBuilder
    SHORTENED_DOMAINS = %w[amzn.to www.amzn.to]
    MAIN_DOMAINS = %w[amazon.com www.amazon.com]

    ENTITY_DOMAINS = SHORTENED_DOMAINS + MAIN_DOMAINS

    def self.valid_domains
      ENTITY_DOMAINS
    end

    def find_or_build_entity
      return entity if entity.persisted?

      affiliate_tag = if SHORTENED_DOMAINS.include?(uri.host)
        get_shortened_tag(uri)
      else
        get_affiliate_tag(uri)
      end

      return nil unless affiliate_tag

      entity.name = affiliate_tag
      entity.kind = 'amazon-affiliate'

      entity
    end

    private

    def get_affiliate_tag(this_uri)
      this_uri.query.match(/tag=(.+)&/)&.captures&.first
    end

    def get_shortened_tag(current_uri, depth = 0)
      return nil if depth > 2

      agent.redirect_ok = false
      agent.get(current_uri)

      redirect_uri = URI(agent.page.header['location'])

      if MAIN_DOMAINS.include?(redirect_uri.host)
        get_affiliate_tag(redirect_uri)
      else
        get_shortened_tag(redirect_uri, depth + 1)
      end
    end
  end
end
