class DownloadsController < ApplicationController
  respond_to :html, :json
  
  def index
    Download.update_status
    respond_with(@downloads = Download.all_ordered)
  end

  def show
    @download = Download.find params[:id]
  end

  def new
    @download = Download.new
  end

  def create
    @download = Download.new params[:download]
    if @download.save
      redirect_to @download, notice: "Successfully created download."
    else
      render action: 'new'
    end
  end

  def update
    @download = Download.find params[:id]
    if @download.update_attributes params[:download]
      redirect_to @download, notice: "Successfully updated download."
    else
      render action: 'edit'
    end
  end

  def destroy
    @download = Download.find params[:id]
    @download.destroy
    redirect_to downloads_url, notice: "Successfully destroyed download."
  end
  
  def add() common_action params              end
  def got() common_action params, :toggle_got end

  def common_action params, action=nil
    @download = Download.find params[:id]
    action = params[:action] if action.nil?
    res = @download.send action

    respond_with(@download) do |format|
      format.html { redirect_to downloads_url, notice: (res ? "#{params[:action]} done" : "Error") }
    end
  end
end
