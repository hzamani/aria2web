class DownloadsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!
  
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
    @download.user = current_user
    if @download.save
      redirect_to @download, notice: "Successfully created download."
    else
      render action: 'new'
    end
  end
  
  def edit
    @download = Download.find params[:id]
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
  
  def add   () send_command params, message: "Added"   end
  def pause () send_command params, message: "Paused"  end
  def resume() send_command params, message: "Resumed" end
  def stop  () send_command params, message: "Stopped", command: :remove end
  
  def send_command params, options={}
    options[:command] ||= params[:action]
    resault = DownloadManager.send options[:command], Download.find(params[:id])
    
    respond_with(resault) do |format|
      format.html { redirect_to downloads_url, notice: resault }
    end
  end
  
  def got  () send_download_command params, :toggle_got,  message: "got toggled"  end
  def keep () send_download_command params, :toggle_keep, message: "keep toggled" end
  
  def send_download_command params, command, options={}
    command           ||= params[:action]
    options[:message] ||= "#{:command} done"
    options[:error]   ||= "Error"
    
    resault = Download.find(params[:id]).send command

    respond_with(resault) do |format|
      format.html { redirect_to downloads_url, notice: (resault ? options[:message] : options[:error]) }
    end
  end
end
