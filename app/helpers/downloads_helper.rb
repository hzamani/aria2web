module DownloadsHelper
  def link_for action, label=nil
    label ||= action
    link_to label, url_for(controller: :downloads, action: action, only_path: true, id: @download.id)
  end
  
  def links_for download
    @download = download
    
    case download.status
    when "new"
      link_for(:add, :start)
    when "active"
      [link_for(:pause), link_for(:stop)]
    when "waiting"
      [link_for(:pause), link_for(:stop)]
    when "paused"
      [link_for(:resume), link_for(:add, :restart)]
    when "stopped"
      link_for(:remove)
    when "error"
      link_for(:add, :retry)
    when "complete"
      [download.got?  ? link_for(:got,  "remove got mark")  : link_for(:got, "mark as got"),
       download.keep? ? link_for(:keep, "remove keep mark") : link_for(:keep, "mark for keep")]
    else
      []
    end
  end
end
