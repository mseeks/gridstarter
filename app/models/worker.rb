class Worker < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :tasks
  
  before_validation :set_provider
  after_create :spin_up!
  before_destroy :rip_down!
  
  # Returns true if the droplet is active(finished spinning up)
  # @return [Boolean] true if active
  def active?
    case self.provider
      when "digital_ocean"
        DigitalOcean.droplet.show(self.uid).droplet.status == "active"
    end
  end
  
  # Destroys the worker instance based on provider and uid
  def rip_down!
    if self.active?
      sleep(10)
      case self.provider
        when "digital_ocean"
          DigitalOcean.droplet.destroy(self.uid)
      end
    else
      sleep(10)
      self.rip_down!
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
