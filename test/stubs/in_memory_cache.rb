# frozen_string_literal: true

class InMemoryCache
  attr_accessor :store

  def initialize
    self.store = {}
  end

  def fetch(key, **_options)
    return store[key] if store.key?(key)

    store[key] = yield
  end
end
