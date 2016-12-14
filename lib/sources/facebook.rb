require 'json'
require_relative './base'

class Source::Facebook < Source::Base
  def run
    {
      facebook: {
        shares: graph_response.dig('share', 'share_count'),
        og_object_id: graph_response.dig('og_object', 'id'),
        facebook_id: graph_response['id']
      }
    }
  end

  def self.domain_task?
    true
  end

  def self.page_task?
    true
  end

  private

  def graph_response
    @graph_response ||= JSON.parse \
      agent.get("http://graph.facebook.com/?id=http://#{domain}").body
  end
end
