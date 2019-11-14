require 'forwardable'
require 'yaml'
require 'gimei/version'
require 'gimei/name'
require 'gimei/address'
require 'gimei/unique_generator'

class Gimei
  extend Forwardable

  NAMES = YAML.load_file(File.expand_path(File.join('..', 'data', 'names.yml'), __FILE__))
  ADDRESSES = YAML.load_file(File.expand_path(File.join('..', 'data', 'addresses.yml'), __FILE__))
  GENDER = [:male, :female].freeze

  def_delegators :@name, :kanji, :hiragana, :katakana, :first, :last, :male?, :female?, :romaji
  def_delegators :@address, :prefecture, :city, :town
  alias_method :to_s, :kanji

  attr_reader :name, :address

  class << self
    extend Forwardable

    def_delegators :name, :kanji, :hiragana, :katakana, :first, :last, :romaji
    def_delegators Gimei::Name, :male, :female
    def_delegators :address, :prefecture, :city, :town

    def name
      Name.new
    end

    def address
      Address.new
    end

    def unique(max_retries = 10_000)
      @unique ||= UniqueGenerator.new(self, max_retries)
    end
  end

  def initialize(gender = nil)
    @name = Name.new(gender)
    @address = Address.new
  end
end
