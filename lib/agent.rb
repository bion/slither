require 'mechanize'

module Agent
  def agent
    @agent ||= Mechanize.new.tap do |agent|
      # randomize user agent
      agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
    end
  end
end
