class LibrariesFetcher
  class Result
    def sort_by(atr)
      self
    end

    def as_json(args)
      []
    end
  end

  def self.call(using:, filters: {})
    Result.new
  end
end
