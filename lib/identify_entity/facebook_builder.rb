require_relative './entity_builder'

class IdentifyEntity
  class FacebookBuilder < EntityBuilder
    ENTITY_DOMAINS = %w[
      facebook.com
      www.facebook.com
    ]

    def self.valid_domains
      ENTITY_DOMAINS
    end

    def find_or_build_entity
      return entity if entity.persisted?

      username = get_username

      return nil unless username

      entity.name = username
      entity.kind = 'facebook-page'

      entity
    end

    private

    def get_username
      return if share_link?

      get_username_by_following_redirects
    end

    def share_link?
      !!uri.path.match(/share[r]?\.php/)
    end

    def get_username_by_following_redirects
      page = agent.get(uri.to_s)
      form = page.forms.first

      form.email = ''
      form.pass = ''

      page = agent.submit(form)

      uri = page.uri

      return if uri.path.include?(".php")

      uri.path.split("/")[1].downcase
    end
  end
end
