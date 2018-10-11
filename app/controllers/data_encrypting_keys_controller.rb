require 'sidekiq/api'

class DataEncryptingKeysController < ApplicationController

  before_action :check_job, only: [:rotate, :status]

  def rotate
    begin
      RotateWorker.perform_async
    rescue SidekiqUniqueJobs::Conflict
      head :accepted
    else
      head :ok
    end
  end

  def status
    if params[:queue].include? 'RotateWorker'
      render json: { message: 'Key rotation has been queued' }
    elsif params[:worker].include? 'RotateWorker'
      render json: { message: 'Key rotation is in progress' }
    else
      render json: { message: 'No key rotation queued or in progress' }
    end
  end

  private

  def check_job
    queue = Sidekiq::Queue.new
    worker = Sidekiq::Workers.new
    params[:queue] = (queue.size > 0 ? queue.map { |job| job['class'] } : Array.new)
    params[:worker] = (worker.size > 0 ?
                        worker.map { |process_id, thread_id, work| work['payload']['class'] } :
                        Array.new)
  end
end
