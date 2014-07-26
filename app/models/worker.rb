class Worker < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :tasks
  
  before_save :set_provider!
  after_create :set_up!
  before_destroy :tear_down!
  
  # Returns true if the droplet is active(finished spinning up)
  # @return [Boolean] true if active
  def active?
    case self.provider
      when "digital_ocean"
        DigitalOcean.droplet.show(self.uid).droplet.status == "active"
    end
  end
  
  # Returns the first publicly available v6 IP address for the worker
  def ip_address
    case self.provider
      when "digital_ocean"
        self.instance.networks.v4.map{|network| network if network.type == "public" }.compact.first.ip_address
    end
  end
  
  def configure!
    sleep(120)
    Net::SSH.start(self.ip_address, "root", key_data: [self.ssh_private_key], keys_only: true, paranoid: false) do |ssh|  
      raw_script = File.open("#{Rails.root.join("app", "templates", "scripts", "ubuntu-14-04-x64", "#{self.project.work_type}.sh.erb")}").read
      script = Erubis::Eruby.new(raw_script).result({ worker: self })
      output = ssh.exec!(script)

      ap output
    end
  end
  
  # Returns the instance object dependent on the provider
  def instance
    case self.provider
      when "digital_ocean"
        DigitalOcean.droplet.show(self.uid).droplet
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

  # Decides the provider of the worker, currently just always sets 'digital_ocean'
  # but later could act as a load balancer between many providers.
  def set_provider!
    self.provider ||= "digital_ocean"
  end
  
  # Macro function that runs all aspects of instance setup
  def set_up!
    self.set_ssh_keys!
    self.spin_up!
    self.configure!
  end
  handle_asynchronously :set_up!, queue: "set_up"

  # Generates the private and public ssh keys, saves them, and then tells the provider
  def set_ssh_keys!
    key = SSHKey.generate
    self.ssh_private_key = key.private_key
    self.ssh_public_key = key.ssh_public_key

    self.ssh_fingerprint = case self.provider
      when "digital_ocean"
        do_key = DigitalOcean.key.create(name: self.id.to_s, public_key: self.ssh_public_key).ssh_key
        do_key.fingerprint if do_key
    end
    sleep(10)
  end
 
  # Create the worker instance based on provider
  def spin_up!
    unless self.uid
      case self.provider
        when "digital_ocean"
          instance = DigitalOcean.droplet.create({
            name: "#{self.project.id}-#{self.id}",
            region: "nyc2",
            size: "512mb",
            image: "ubuntu-14-04-x64",
            ssh_keys: [self.ssh_fingerprint]
          })
        
          self.uid = instance.droplet.id
          self.save
      end
    end
  end

  # Macro function that runs all aspects of instance teardown
  def tear_down!
    self.rip_down!
  end
  handle_asynchronously :tear_down!, queue: "tear_down"
end
