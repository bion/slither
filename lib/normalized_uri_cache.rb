require 'set'

class NormalizedURICache
  def initialize
    @cache = Set.new
  end

  def seen?(uri)
    @cache.include?(normalize(uri))
  end

  def add(uri)
    @cache.add(normalize(uri))
  end

  private

  def normalize(uri)
    "#{uri.host}-#{uri.path}"
  end
end
