require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Download.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Download.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Download.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to download_url(assigns(:download))
  end

  def test_edit
    get :edit, :id => Download.first
    assert_template 'edit'
  end

  def test_update_invalid
    Download.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Download.first
    assert_template 'edit'
  end

  def test_update_valid
    Download.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Download.first
    assert_redirected_to download_url(assigns(:download))
  end

  def test_destroy
    download = Download.first
    delete :destroy, :id => download
    assert_redirected_to downloads_url
    assert !Download.exists?(download.id)
  end
end
