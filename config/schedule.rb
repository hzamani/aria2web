# Customize to feet your needs
# Don't forget to run `whenever -w' to write command to crontab

set :output, File.expand_path('../../log/cron.log', __FILE__)

every 1.day, at: "8:00 am" do
  runner "DownloadManager.limit"
end

every 1.day, at: "6:00 pm" do
  runner "DownloadManager.unlimit"
end

every 1.day do
  runner "DownloadManager.cleanup_files"
end

every 5.minute do
  runner "DownloadManager.add_all"
  runner "DownloadManager.update_status_all"
end

# Learn more: http://github.com/javan/whenever
