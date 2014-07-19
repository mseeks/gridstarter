class Report
  attr_reader :data, :errors, :tasks
  
  def initialize(data = nil)
    @errors = []
    
    if data.nil?
      @errors << "Invalid data." if data.nil?
    else
      @data = data
      
      case @worker.project.work_type
        when "boinc"
          @tasks = data[:tasks].map do |task|
            {
              uid: task[:name],
              progress: task[:fraction_done] * 100.0
            }
          end
      end
    end
  end
end
