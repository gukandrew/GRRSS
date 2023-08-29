# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :job_template, "/bin/sh -l -c ':job'" # alpine was complaining about not having the bash shell
set :output, "/docker/app/log/cron_log.log" # log file for cron jobs in alpine container, change to /path/to/my/cron_log.log for local

every 1.minute do
  runner "Feed.trigger_active!"
end
