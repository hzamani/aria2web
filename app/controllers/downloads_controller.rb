class DownloadsController < ApplicationController
  def index
    @downloads = Download.all
  end

  def show
    @download = Download.find(params[:id])
  end

  def new
    @download = Download.new
  end

  def create
    @download = Download.new(params[:download])
    if @download.save
      redirect_to @download, :notice => "Successfully created download."
    else
      render :action => 'new'
    end
  end

  def edit
    @download = Download.find(params[:id])
  end

  def update
    @download = Download.find(params[:id])
    if @download.update_attributes(params[:download])
      redirect_to @download, :notice  => "Successfully updated download."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @download = Download.find(params[:id])
    @download.destroy
    redirect_to downloads_url, :notice => "Successfully destroyed download."
  end
end
