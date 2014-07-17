class Task < ActiveRecord::Base
  belongs_to :worker
  
  def complete?
    self.progress == 100.0
  end
end
