# frozen_string_literal: true
# typed: false

class Vonage::Messaging::Channels::MessengerTest < Vonage::Test
  def test_instagram_initialize
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'text', message: 'Hello world!'
    )

    assert_kind_of Vonage::Messaging::Channels::Instagram, message
    assert_equal message.data, {
      channel: 'instagram', message_type: 'text', text: 'Hello world!'
    }
  end

  def test_with_valid_type_text_specified
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'text', message: 'Hello world!'
    )

    assert_equal 'text', message.data[:message_type]
    assert_includes message.data, :text
  end

  def test_with_valid_type_image_specified
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'image',
      message: { url: 'https://example.com/image.jpg' }
    )

    assert_equal 'image', message.data[:message_type]
    assert_includes message.data, :image
  end

  def test_with_valid_type_audio_specified
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'audio',
      message: { url: 'https://example.com/audio.mp3' }
    )

    assert_equal 'audio', message.data[:message_type]
    assert_includes message.data, :audio
  end

  def test_with_valid_type_video_specified
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'video',
      message: { url: 'https://example.com/video.mp4' }
    )

    assert_equal 'video', message.data[:message_type]
    assert_includes message.data, :video
  end

  def test_with_valid_type_file_specified
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'file',
      message: { url: 'https://example.com/file.pdf' }
    )

    assert_equal 'file', message.data[:message_type]
    assert_includes message.data, :file
  end

  def test_with_invalid_type_specified
    exception = assert_raises do
      Vonage::Messaging::Channels::Instagram.new(
        type: 'vcard',
        message: { url: 'https://example.com/contact.vcf' }
      )
    end

    assert_instance_of Vonage::ClientError, exception
    assert_match 'Invalid message type', exception.message
  end

  def test_with_valid_message_class
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'image',
      message: { url: 'https://example.com/image.jpg' }
    )

    assert_kind_of Hash, message.data[:image]
  end

  def test_with_invalid_message_class
    exception = assert_raises do
      Vonage::Messaging::Channels::Instagram.new(
        type: 'image', message: 'https://example.com/image.jpg'
      )
    end

    assert_instance_of Vonage::ClientError, exception
    assert_match ':message must be a Hash', exception.message
  end

  def test_object_message_without_url
    exception = assert_raises do
      Vonage::Messaging::Channels::Instagram.new(
        type: 'image',
        message: {}
      )
    end

    assert_instance_of Vonage::ClientError, exception
    assert_match ':url is required in :message', exception.message
  end

  def test_with_opts_client_ref
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'text',
      message: 'Hello world!',
      opts: { client_ref: 'abc123' }
    )

    assert_equal 'abc123', message.data[:client_ref]
  end

  def test_with_opts_instagram_object
    message = Vonage::Messaging::Channels::Instagram.new(
      type: 'text',
      message: 'Hello world!',
      opts: {
        instagram: { 
          category: 'response', 
          tag: 'CONFIRMED_EVENT_UPDATE' 
        }
      }
    )

    assert_equal 'response', message.data[:instagram][:category]
    assert_equal 'CONFIRMED_EVENT_UPDATE', message.data[:instagram][:tag]
  end
end
