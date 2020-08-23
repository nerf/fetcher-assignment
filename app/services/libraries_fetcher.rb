class LibrariesFetcher
  class Results
    def sort_by(atr)
      self
    end

    def as_json(args)
      []
    end

    def <<(list)
    end
  end

  def self.call(using: [], lang: nil)
    results = Results.new

    using.each do |fetcher|
      results << fetcher.latest_public_libraries(lang: lang)
    end

    results
  end
end
