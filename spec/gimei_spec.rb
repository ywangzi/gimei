# coding: utf-8
require_relative 'spec_helper'

describe Gimei do
  describe '.male' do
    before { @name = Gimei.male }

    it 'Gimei::Name オブジェクトが返ること' do
      @name.must_be_instance_of Gimei::Name
    end

    it '#male? が true を返すこと' do
      @name.male?.must_equal true
    end
  end

  describe '.female' do
    before { @name = Gimei.female }

    it 'Gimei::Name オブジェクトが返ること' do
      @name.must_be_instance_of Gimei::Name
    end

    it '#female? が true を返すこと' do
      @name.female?.must_equal true
    end
  end

  describe '#kanji' do
    it '全角文字とスペースが返ること' do
      Gimei.new.kanji.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '#to_s' do
    it '全角文字とスペースが返ること' do
      Gimei.new.to_s.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '.kanji' do
    it '全角文字とスペースが返ること' do
      Gimei.kanji.must_match /\A[#{Moji.zen}\s]+\z/
    end
  end

  describe '#hiragana' do
    it 'ひらがなとスペースが返ること' do
      Gimei.new.hiragana.must_match /\A[\p{hiragana}\s]+\z/
    end
  end

  describe '.hiragana' do
    it 'ひらがなとスペースが返ること' do
      Gimei.hiragana.must_match /\A[\p{hiragana}\s]+\z/
    end
  end

  describe '#katakana' do
    it 'カタカナとスペースが返ること' do
      Gimei.new.katakana.must_match /\A[\p{katakana}\s]+\z/
    end
  end

  describe '.katakana' do
    it 'カタカナとスペースが返ること' do
      Gimei.katakana.must_match /\A[\p{katakana}\s]+\z/
    end
  end

  describe '.name' do
    it 'Gimei::Name オブジェクトが返ること' do
      Gimei.name.must_be_instance_of Gimei::Name
    end
  end

  describe '#name' do
    it 'Gimei::Name オブジェクトが返ること' do
      Gimei.new.name.must_be_instance_of Gimei::Name
    end
  end

  describe '.first' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.first.must_be_instance_of Gimei::Name::First
    end
  end

  describe '#first' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.new.first.must_be_instance_of Gimei::Name::First
    end
  end

  describe '.last' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.last.must_be_instance_of Gimei::Name::Last
    end
  end

  describe '#last' do
    it 'Gimei::Name::First オブジェクトが返ること' do
      Gimei.new.last.must_be_instance_of Gimei::Name::Last
    end
  end

  describe '.romaji' do
    it 'ローマ字とスペースが返ること' do
      Gimei.romaji.must_match(/\A[a-zA-Z\s]+\z/)
    end
  end

  describe '#romaji' do
    it 'ローマ字とスペースが返ること' do
      Gimei.new.romaji.must_match(/\A[a-zA-Z\s]+\z/)
    end
  end

  describe '.address' do
    it 'Gimei::Address オブジェクトが返ること' do
      Gimei.address.must_be_instance_of Gimei::Address
    end
  end

  describe '#address' do
    it 'Gimei::Address オブジェクトが返ること' do
      Gimei.new.address.must_be_instance_of Gimei::Address
    end
  end

  describe '.prefecture' do
    it 'Gimei::Address::Prefecture オブジェクトが返ること' do
      Gimei.prefecture.must_be_instance_of Gimei::Address::Prefecture
    end
  end

  describe '#prefecture' do
    it 'Gimei::Address::Prefecture オブジェクトが返ること' do
      Gimei.new.prefecture.must_be_instance_of Gimei::Address::Prefecture
    end
  end

  describe '.city' do
    it 'Gimei::Address::City オブジェクトが返ること' do
      Gimei.city.must_be_instance_of Gimei::Address::City
    end
  end

  describe '#city' do
    it 'Gimei::Address::City オブジェクトが返ること' do
      Gimei.new.city.must_be_instance_of Gimei::Address::City
    end
  end

  describe '.town' do
    it 'Gimei::Address::Town オブジェクトが返ること' do
      Gimei.town.must_be_instance_of Gimei::Address::Town
    end
  end

  describe '#town' do
    it 'Gimei::Address::Town オブジェクトが返ること' do
      Gimei.new.town.must_be_instance_of Gimei::Address::Town
    end
  end

  describe '.unique' do
    describe '#name' do
      context '名前が枯渇していないとき' do
        it '一意な名前(フルネームの漢字単位)が返ること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [['真一', 'しんいち', 'シンイチ']], 'female' => [] },
            'last_name' => %w[前島 神谷]
          }
          [Gimei.unique.name.kanji, Gimei.unique.name.kanji].sort.must_equal ['前島 真一', '神谷 真一']
          Gimei::NAMES = original_names
        end
      end

      context '名前が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => []
          }
          assert_raises Gimei::RetryLimitExceed do
            Gimei.unique.name
          end
          Gimei::NAMES = original_names
        end
      end
    end

    describe '#first' do
      context '名が枯渇していないとき' do
        it '一意な名(漢字単位)が返ること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [['真一', 'しんいち', 'シンイチ']], 'female' => [['花子', 'はなこ', 'ハナコ']] },
            'last_name' => %w[]
          }
          [Gimei.unique.first.kanji, Gimei.unique.first.kanji].sort.must_equal %w[真一 花子]
          Gimei::NAMES = original_names
        end
      end

      context '名が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
          original_names = Gimei::NAMES
          Gimei::NAMES = {
            'first_name' => { 'male' => [], 'female' => [] },
            'last_name' => []
          }
          assert_raises Gimei::RetryLimitExceed do
            Gimei.unique.first
          end
          Gimei::NAMES = original_names
        end
      end
    end

    describe '#last' do
      context '姓が枯渇していないとき' do
        it '一意な姓(漢字単位)が返ること' do
        end
      end

      context '姓が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
        end
      end
    end

    describe '#address' do
      context '住所が枯渇していないとき' do
        it '一意な住所(漢字単位)が返ること' do
        end
      end

      context '住所が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
        end
      end
    end

    describe '#prefecture' do
      context '県が枯渇していないとき' do
        it '一意な県が返ること' do
        end
      end

      context '県が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
        end
      end
    end

    describe '#city' do
      context '市区町村が枯渇していないとき' do
        it '一意な市区町村が返ること' do
        end
      end

      context '市区町村が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
        end
      end
    end

    describe '#town' do
      context 'その他住所が枯渇していないとき' do
        it '一意なその他住所が返ること' do
        end
      end

      context 'その他住所が枯渇したとき' do
        it 'Gimei::RetryLimitExceed例外が発生すること' do
        end
      end
    end
  end
end
