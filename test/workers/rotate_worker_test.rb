require 'test_helper'
require 'sidekiq/testing'

class RotateWorkerTest < ActiveSupport::TestCase

=begin
  def test_example
    skip "add some examples to (or delete) #{__FILE__}"
  end
=end

  def setup
    Sidekiq::Testing.fake!
  end

  def teardown
    Sidekiq::Worker.clear_all
    clear_unique_from_redis
  end

  def test_one_job
    RotateWorker.perform_async
    assert_equal(1, RotateWorker.jobs.size)
  end

  def test_multiple_jobs
    assert_raises(SidekiqUniqueJobs::Conflict) do
      for i in 0..1
        RotateWorker.perform_async
      end
    end
  end
end
