require 'sidekiq/api'

class DataEncryptingKeysController < ApplicationController

  before_action :check_job, only: [:rotate, :status]

  def rotate
    if params[:queued] > 0 || params[:worker] != 0
      head :accepted
    else
      begin
        RotateWorker.perform_async
      rescue SidekiqUniqueJobs::Conflict
        head :accepted
      else
        head :ok
      end
    end
  end

  def status
    if params[:queued] > 0
      render json: { message: 'Key rotation has been queued' }
    elsif params[:worker] == 'RotateWorker'
      render json: { message: 'Key rotation is in progress' }
    else
      render json: { message: 'No key rotation queued or in progress' }
    end
  end

  private

  def check_job
    params[:queued] = Sidekiq::Queue.new.size
    worker = Sidekiq::Workers.new
    params[:worker] = worker.size
    if worker.size > 0
      worker = worker.map { |process_id, thread_id, work| work['payload']['class'] }
      params[:worker] = 'RotateWorker' if worker.include? 'RotateWorker'
    end
  end
end
