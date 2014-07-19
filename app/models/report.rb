class Report
  attr_reader :data, :errors, :tasks, :work_type
  
  def initialize(data: nil, work_type: nil)
    @errors = []
    @work_type = work_type
    
    if data.nil?
      @errors << "Invalid data." if data.nil?
    else
      @data = data
      
      case @work_type
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
