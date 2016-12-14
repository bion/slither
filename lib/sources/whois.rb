require 'open3'
require_relative './base'

class Source::Whois < Source::Base
  def run
    { registrant_name: get_registrant_name }
  end

  def self.domain_task?
    true
  end

  private

  def get_registrant_name
    stdout = Open3.capture3("whois #{domain}")[0]

    stdout
      .match(/Registrant Name: (.*)\n/)
      &.captures
      &.first
  end
end
