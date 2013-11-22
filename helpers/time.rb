class Application < Sinatra::Base
  include HTTParty
  helpers do
    def today
      time = Time.now.utc
      Time.utc(time.year, time.month, time.day)
    end

    def yesterday
      time = Time.new.utc - (60 * 60 * 24)
      Time.utc(time.year, time.month, time.day)
    end

    def tomorrow
      time = Time.new.utc + (60 * 60 * 24)
      Time.utc(time.year, time.month, time.day)
    end

    def next_week
      time = Time.new.utc + (60 * 60 * 24)*7
      Time.utc(time.year, time.month, time.day)
    end

    def last_week
      time = Time.new.utc - (60 * 60 * 24)*7
      Time.utc(time.year, time.month, time.day)
    end

    def last_month
      time = Time.new.utc - (60 * 60 * 24)*30
      Time.utc(time.year, time.month, time.day)
    end

    def next_month
      time = Time.new.utc + (60 * 60 * 24)*30
      Time.utc(time.year, time.month, time.day)
    end
  end
end