# frozen_string_literal: true
# typed: true

module Vonage
  class Messaging::Channels::Instagram < Messaging::Message
    MESSAGE_TYPES = %w[text image audio video file].freeze

    attr_reader :data

    # initializes a Vonage::Message for Instagram
    # @param [Hash] attributes
    def initialize(attributes = {})
      @type = attributes.fetch(:type, nil)
      @message = attributes.fetch(:message, nil)
      @opts = attributes.fetch(:opts, {})
      @data = {}

      after_initialize!
    end

    private

    # sets channel to 'instagram' and calls super creating a Vonage::Message
    #   to be sent via SDK
    # @return Message
    def build
      data[:channel] = 'instagram'
      super
    end

    # raises ClientError if message has an invalid type from defined 
    #   MESSAGE_TYPES
    # @raise [Vonage::ClientError]
    def verify_type
      raise Vonage::ClientError, 'Invalid message type' unless
        MESSAGE_TYPES.include?(type)
    end

    # raises ClientError if message has invalid arguments
    # @raise [Vonage::ClientError]
    # @return nil
    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError, ':message must be a String' unless
          message.is_a? String
      else
        raise Vonage::ClientError, ':message must be a Hash' unless
          message.is_a? Hash
        raise Vonage::ClientError, ':url is required in :message' unless
          message[:url]
      end
    end
  end
end
