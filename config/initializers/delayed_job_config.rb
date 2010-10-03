# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = true

# Only try ONCE.
Delayed::Worker.max_attempts = 1

# Kill any job that failed within the update resolution (this is primarily for update messages)
Delayed::Worker.max_run_time = 30.seconds