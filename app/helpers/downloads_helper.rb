module DownloadsHelper
  def links_for download
    case download.status
    when "new"
      [link_to("start", add_download_url(download))]
    when "active"
      [link_to("pause"), link_to("stop")]
    when "waiting"
      [link_to("pause"), link_to("stop")]
    when "paused"
      [link_to("resume")]
    when "stopped"
      [link_to("remove")]
    when "error"
      [link_to("retry")]
    when "complete"
      if download.got?
        [link_to("remove got mark", got_download_url(download))]
      else
        [link_to("mark as got", got_download_url(download))]
      end
    else
      []
    end
  end
end
