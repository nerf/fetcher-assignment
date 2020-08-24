# frozen_string_literal: true

class LibrariesFetcher
  class Results
    attr_reader :results

    def initialize
      @results = []
    end

    def <<(list)
      return unless list

      @results = results.concat(list.compact)

      self
    end

    def sort_by(atr)
      @results = results.sort_by { |r| r.public_send(atr) }

      self
    end

    def as_json(args = {})
      results.map { |r| r.as_json(args) }
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
