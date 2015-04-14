require 'kinja/client'

module Kinja
  autoload :VERSION, File.join(File.dirname(__FILE__), 'kinja/version')

  class << self
    def new(options={})
      Kinja::Client.new(options)
    end
  end
end
