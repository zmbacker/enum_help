require 'spec_helper'

EnumHelp::Railtie.initializers.each(&:run)

class User < ActiveRecord::Base
  if ActiveRecord.version < Gem::Version.new('6.1')
    enum gender: [:male, :female]
  elsif ActiveRecord.version < Gem::Version.new('7.0')
    enum gender: [:male, :female], _default: :male
  else # Rails 7.0 or higher
    enum :gender, [:male, :female], default: :male
  end

  enum status: %i[normal disable]
end

RSpec.describe EnumHelp::I18n do
  describe '#enum' do
    context 'With hash definitions' do
      it 'responds defined _i18n method' do
        expect(User.new).to respond_to("gender_i18n")
      end

      it 'responds defined genders_i18n method' do
        expect(User).to respond_to("genders_i18n")
      end
    end

    context 'With array definitions' do
      it 'responds defined _i18n method' do
        expect(User.new).to respond_to("status_i18n")
      end

      it 'responds defined status_i18n method' do
        expect(User).to respond_to("statuses_i18n")
      end
    end
  end

  describe '#enum_key_i18n' do
    describe 'user.gender' do
      let(:gender) { "female" }
      let(:user) { User.create(gender: gender) }


      subject { user.gender_i18n }

      context 'lang is zh-CN' do
        before { I18n.locale = :"zh-CN" }

        it { expect(I18n.locale).to eq :"zh-CN" }

        context 'gender is male' do
          let(:gender) { 'male' }
          it { is_expected.to eq '男' }
        end

        context 'gender is female' do
          let(:gender) { 'female' }
          it { is_expected.to eq '女' }
        end
      end

      context 'lang is en' do
        before { I18n.locale = :en }

        it { expect(I18n.locale).to eq :en }

        context 'gender is male' do
          let(:gender) { 'male' }
          it { is_expected.to eq 'Male' }
        end

        context 'gender is female' do
          let(:gender) { 'female' }
          it { is_expected.to eq 'Female' }
        end
      end
    end
  end

  describe '#enum_keys_i18n' do
    subject { User.genders_i18n }

    context 'lang is zh-CN' do
      before { I18n.locale = :"zh-CN" }

      it { expect(I18n.locale).to eq :"zh-CN" }
      it { is_expected.to eq({"male"=>"男", "female"=>"女"}) }
    end

    context 'lang is en' do
      before { I18n.locale = :en }

      it { expect(I18n.locale).to eq :en }
      it { is_expected.to eq({"male"=>"Male", "female"=>"Female"}) }
    end
  end
end
