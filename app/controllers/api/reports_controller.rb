module Api
  class ReportsController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    
    # POST /api/reports.json
    def create
      @worker = Worker.find(report_params[:meta][:worker_id])
      @tasks = []
      
      if @worker
        @report = Report.new(data: report_params, work_type: @worker.project.work_type)
        
        if @report.errors.length == 0
          @report.tasks.each do |task_hash|
            task = @worker.tasks.where(uid: task_hash[:uid]).first_or_create
            task.progress = task_hash[:progress]
            
            @tasks << task
          end
          
          render json: @tasks, status: :success
        else
          render json: @report.errors, status: :unprocessable_entity
        end
      end
    end
    
    private
    
    def report_params
      params[:report]
    end
  end
end
