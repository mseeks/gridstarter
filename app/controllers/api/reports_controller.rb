module Api
  class ReportsController < ApplicationController
    responds_to :json
    
    # POST /api/reports.json
    def create
      @worker = Worker.find(meta_params[:worker_id])
      @tasks = []
      
      if @worker
        @report = Report.new(report_params)
        
        if @report.errors.length == 0
          @report.tasks.each do |task_hash|
            task = Task.where(uid: task_hash[:uid]).first_or_create
            task.progress = task_hash[:progress]
            
            @tasks << task
          end
          
          respond_with @tasks
        else
          render json: @report.errors, status: :unprocessable_entity
        end
      end
    end
    
    private
    
    def meta_params
      params.require(:meta).permit(:worker_id)
    end
    
    def report_params
      params[:report]
    end
  end
end
