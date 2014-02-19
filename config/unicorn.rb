worker_count = ENV['UNICORN_COUNT'].to_i

worker_processes = (worker_count > 0) ? worker_count : 4
timeout 30
preload_app true


before_fork do |server, worker|

  # any DB cleanup may be required (activerecord, redis, etc.)
  sleep 1
end


after_fork do |server, worker|

  #other DB setup may be reuquired (redis, etc.)
end