Sidekiq.configure_server do |config|
  config.death_handlers << ->(job, _ex) do
    SidekiqUniqueJobs::Digests.del(digest: job['unique_digest']) if job['unique_digest']
  end
end

=begin
# disable sidekiq-unique-jobs for testing
SidekiqUniqueJobs.configure do |config|
  config.enabled = !Rails.env.test?
end
=end
