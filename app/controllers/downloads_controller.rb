class DownloadsController < ApplicationController
  respond_to :html, :json
  
  def index
    DownloadManager.update_status_all
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
  
  def stat
    status = DownloadManager.status Download.find(params[:id])
    render json: status
  end
  
  def add
    resault = DownloadManager.add Download.find(params[:id])

    respond_with(resault) do |format|
      format.html { redirect_to downloads_url, notice: (resault ? "Added" : "Error") }
    end
  end
  
  def got
    resault = Download.find(params[:id]).toggle_got

    respond_with(resault) do |format|
      format.html { redirect_to downloads_url, notice: (resault ? "Toggled" : "Error") }
    end
  end
end
