require 'test_helper'

class DownloadTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Download.new.valid?
  end
end
