# this is edited source from stympy/faker
# Copyright (c) 2007-2019 Benjamin Curtis
# https://github.com/stympy/faker/blob/master/License.txt

class UniqueGenerator
  class RetryLimitExceeded < StandardError; end

  @marked_unique = Set.new

  class << self
    attr_reader :marked_unique

    def clear
      marked_unique.each(&:clear)
      marked_unique.clear
    end
  end

  def initialize(generator, max_retries)
    @generator = generator
    @max_retries = max_retries
    @previous_results = Hash.new { |hash, key| hash[key] = Set.new }
  end

  def clear
    previous_results.clear
  end

  private

  attr_reader :max_retries, :previous_results

  def method_missing(name)
    return super unless respond_to_missing?(name)

    self.class.marked_unique.add(self)

    max_retries.times do
      result = generator.public_send(name)

      next if previous_results[name].include?(result.to_s)

      previous_results[name] << result.to_s
      return result
    end

    raise RetryLimitExceeded, "Retry limit exceeded for #{name}"
  end

  def respond_to_missing?(method_name, include_all = false)
    @generator.respond_to?(method_name, include_all) || super
  end
end
