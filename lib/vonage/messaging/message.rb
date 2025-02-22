# typed: true

module Vonage
  class Messaging::Message
    CHANNELS = {
      sms: Vonage::Messaging::Channels::SMS,
      mms: Vonage::Messaging::Channels::MMS,
      rcs: Vonage::Messaging::Channels::RCS,
      whatsapp: Vonage::Messaging::Channels::WhatsApp,
      messenger: Vonage::Messaging::Channels::Messenger,
      viber: Vonage::Messaging::Channels::Viber,
      instagram: Vonage::Messaging::Channels::Instagram
    }

    class << self
      CHANNELS.keys.each do |method|
        define_method method do |attributes|
          CHANNELS[method].new(**attributes).data
        end
      end
    end

    def self.method_missing(method)
      raise ClientError.new("Messaging channel must be one of the valid options.")
    end

    private

    attr_accessor :type, :message, :opts
    attr_writer :data

    def after_initialize!
      verify_type
      verify_message
      build
    end

    def build
      data[:message_type] = type
      data[type.to_sym] = message
      data.merge!(opts)
    end
  end
end
