class Worker < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :tasks
  
  before_validation :set_provider
  after_create :spin_up!
  before_destroy :rip_down!
  
  # Destroys the worker instance based on provider and uid
  def rip_down!
    case self.provider
      when "digital_ocean"
        DigitalOcean.droplet.destroy(self.uid)
    end
  end
  
  # Create the worker instance based on provider
  def spin_up!
    unless self.uid
      case self.provider
        when "digital_ocean"
          virtual_machine = DigitalOcean.droplet.create({
            name: "#{self.project.id}-#{self.id}",
            region: "nyc2",
            size: "512mb",
            image: "ubuntu-14-04-x64"
          })
        
          self.uid = virtual_machine.droplet.id
          self.save
      end
    end
  end
  
  # Decides the provider of the worker, currently just always sets 'digital_ocean'
  # but later could act as a load balancer between many providers.
  def set_provider
    self.provider ||= "digital_ocean"
  end
end
