module Kinja
  module Analytics
    def get_counts(id)
      HTTParty.get(analytics_path(id))["data"].first
    end
  end
end


