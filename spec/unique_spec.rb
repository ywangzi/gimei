# coding: utf-8
require_relative 'spec_helper'

describe 'Gimei.unique' do
  before do
    Gimei.unique.clear
  end
  # TODO: kanji hiragana katakana romaji
  describe '#male' do
    describe '名前が枯渇していないとき' do
      it '一意な名前(フルネームの漢字単位)が返ること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [%w[真一 しんいち シンイチ]] },
          'last_name' => [%w[前島 まえしま マエシマ], %w[神谷 かみや カミヤ]]
        }
        _([Gimei.unique.male.kanji, Gimei.unique.male.kanji].sort).must_equal ['前島 真一', '神谷 真一']
        Gimei::NAMES = original_names
      end
    end

    describe '名前が枯渇したとき' do
      it 'Gimei::RetryLimitExceededed例外が発生すること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [%w[真一 しんいち シンイチ]] },
          'last_name' => [%w[前島 まえしま マエシマ]]
        }

        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.male
          Gimei.unique.male
        end
        Gimei::NAMES = original_names
      end
    end
  end

  describe '#first' do
    describe '名が枯渇していないとき' do
      it '一意な名(漢字単位)が返ること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [%w[真一 しんいち シンイチ], %w[真二 しんじ シンジ]] },
          'last_name' => %w[]
        }
        _([Gimei.unique.first(:male).kanji, Gimei.unique.first(:male).kanji].sort).must_equal %w[真一 真二]
        Gimei::NAMES = original_names
      end
    end

    describe '名が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [%w[真一 しんいち シンイチ]] },
          'last_name' => []
        }

        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.first(:male)
          Gimei.unique.first(:male)
        end
        Gimei::NAMES = original_names
      end
    end
  end

  describe '#last' do
    describe '姓が枯渇していないとき' do
      it '一意な姓(漢字単位)が返ること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [], 'female' => [] },
          'last_name' => [%w[前島 まえしま マエシマ], %w[神谷 かみや カミヤ]]
        }
        _([Gimei.unique.last.kanji, Gimei.unique.last.kanji].sort).must_equal %w[前島 神谷]
        Gimei::NAMES = original_names
      end
    end

    describe '姓が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_names = Gimei::NAMES
        Gimei::NAMES = {
          'first_name' => { 'male' => [], 'female' => [] },
          'last_name' => [%w[前島 まえしま マエシマ]]
        }
        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.last
          Gimei.unique.last
        end
        Gimei::NAMES = original_names
      end
    end
  end

  describe '#address' do
    describe '住所が枯渇していないとき' do
      it '一意な住所(漢字単位)が返ること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [%w[東京都 とうきょうと トウキョウト]],
            'city' => [%w[渋谷区 しぶやく シブヤク]],
            'town' => [%w[恵比寿 えびす エビス], %w[蛭子 えびす エビス]]
          }
        }
        _([Gimei.unique.address.kanji, Gimei.unique.address.kanji].sort).must_equal %w[東京都渋谷区恵比寿 東京都渋谷区蛭子]
        Gimei::ADDRESSES = original_addresses
      end
    end

    describe '住所が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [%w[東京都 とうきょうと トウキョウト]],
            'city' => [%w[渋谷区 しぶやく シブヤク]],
            'town' => [%w[恵比寿 えびす エビス]]
          }
        }
        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.address
          Gimei.unique.address
        end
        Gimei::ADDRESSES = original_addresses
      end
    end
  end

  describe '#prefecture' do
    describe '県が枯渇していないとき' do
      it '一意な県が返ること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [%w[東京都 とうきょうと トウキョウト], %w[静岡県 しずおかけん シズオカケン]],
            'city' => [],
            'town' => []
          }
        }
        _([Gimei.unique.prefecture.kanji, Gimei.unique.prefecture.kanji].sort).must_equal %w[東京都 静岡県]
        Gimei::ADDRESSES = original_addresses
      end
    end

    describe '県が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [%w[東京都 とうきょうと トウキョウト]],
            'city' => [],
            'town' => []
          }
        }
        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.prefecture
          Gimei.unique.prefecture
        end
        Gimei::ADDRESSES = original_addresses
      end
    end
  end

  describe '#city' do
    describe '市区町村が枯渇していないとき' do
      it '一意な市区町村が返ること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [],
            'city' => [%w[渋谷区 しぶやく シブヤク], %w[新宿区 しんじゅくく シンジュクク]],
            'town' => []
          }
        }
        _([Gimei.unique.city.kanji, Gimei.unique.city.kanji].sort).must_equal %w[新宿区 渋谷区]
        Gimei::ADDRESSES = original_addresses
      end
    end

    describe '市区町村が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [],
            'city' => [%w[渋谷区 しぶやく シブヤク]],
            'town' => []
          }
        }
        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.city
          Gimei.unique.city
        end
        Gimei::ADDRESSES = original_addresses
      end
    end
  end

  describe '#town' do
    describe 'その他住所が枯渇していないとき' do
      it '一意なその他住所が返ること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [],
            'city' => [],
            'town' => [%w[恵比寿 えびす エビス], %w[蛭子 えびす エビス]]
          }
        }
        _([Gimei.unique.town.kanji, Gimei.unique.town.kanji].sort).must_equal %w[恵比寿 蛭子]
        Gimei::ADDRESSES = original_addresses
      end
    end

    describe 'その他住所が枯渇したとき' do
      it 'Gimei::RetryLimitExceeded例外が発生すること' do
        original_addresses = Gimei::ADDRESSES
        Gimei::ADDRESSES = {
          'addresses' => {
            'prefecture' => [],
            'city' => [],
            'town' => [%w[恵比寿 えびす エビス]]
          }
        }
        assert_raises Gimei::RetryLimitExceeded do
          Gimei.unique.town
          Gimei.unique.town
        end
        Gimei::ADDRESSES = original_addresses
      end
    end
  end
end
