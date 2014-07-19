module Api
  class ReportsController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    
    # POST /api/reports.json
    def create
      @worker = Worker.find(params[:worker_id])
      @tasks = []
      
      if @worker
        report_params[:tasks].each do |task_hash|
          task = @worker.tasks.where(uid: task_hash[:name]).first_or_initialize
          task.progress = task[:fraction_done] * 100.0
          task.save
          
          @tasks << task
        end
      end
    end
    
    private
    
    def report_params
      params[:report]
    end
  end
end
