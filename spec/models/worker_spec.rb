require "spec_helper"

# ---------------------------------------------------------
# Class Methods
# ---------------------------------------------------------

# ---------------------------------------------------------
# Instance Methods
# ---------------------------------------------------------
describe Worker, "#active?" do
  before(:each) do
    VCR.use_cassette(:worker_active_create) do
      @worker = create(:worker)
      @worker.set_provider!
      @worker.set_ssh_keys!
      @worker.spin_up!
    end
  end
  

  it "should return false if instance is still setting up" do
    VCR.use_cassette(:worker_active_get_false) do
      expect(@worker.active?).to be_falsey
    end
  end

  it "should return true if instace is up and running" do
    sleep(60)
    VCR.use_cassette(:worker_active_get_true) do
      expect(@worker.active?).to be_truthy
    end
  end
  
  after(:each) do
    VCR.use_cassette(:worker_active_rip_down) do
      @worker.rip_down!
    end
  end
end

describe Worker, "#ip_address" do
  before(:all) do
    VCR.use_cassette(:worker_ip_address_create) do
      @worker = create(:worker)
      @worker.set_provider!
      @worker.set_ssh_keys!
      @worker.spin_up!
    end
  end

  it "should return the ip_address for the worker instance" do
    VCR.use_cassette(:worker_ip_address_get) do
      expect(@worker.ip_address).to_not be_nil
    end
  end
  
  after(:all) do
    VCR.use_cassette(:worker_ip_address_rip_down) do
      @worker.rip_down!
    end
  end
end

describe Worker, "#set_ssh_keys!" do
  before(:all) do
    VCR.use_cassette(:worker_set_ssh_keys_create) do
      @worker = create(:worker)
      @worker.set_provider!
      @worker.set_ssh_keys!
    end
  end

  it "should set the ssh_private_key for the worker instance" do
    expect(@worker.ssh_private_key).to_not be_nil
  end

  it "should set the ssh_public_key for the worker instance" do
    expect(@worker.ssh_public_key).to_not be_nil
  end

  it "should set the ssh_fingerprint for the worker instance" do
    expect(@worker.ssh_fingerprint).to_not be_nil
  end
end

describe Worker, "#spin_up!" do
  before(:all) do
    VCR.use_cassette(:worker_spin_up_create) do
      @worker = create(:worker)
      @worker.set_provider!
      @worker.set_ssh_keys!
      @worker.spin_up!
    end
  end

  it "should create the worker instance" do
    VCR.use_cassette(:worker_spin_up_retrieve_all) do
      worker_instances = case @worker.provider
        when "digital_ocean"
          DigitalOcean.droplet.all.droplets
      end
  
      expect(worker_instances).to include(a_hash_including(id: @worker.uid))
    end
  end

  it "should record the uid of the virtual instance" do
    expect(@worker.uid).not_to be_nil
  end
  
  after(:all) do
    VCR.use_cassette(:worker_spin_up_destroy) do
      @worker.rip_down!
    end
  end
end

describe Worker, "#rip_down!" do
  before(:all) do
    VCR.use_cassette(:worker_rip_down_create) do
      @worker = create(:worker)
      @worker.set_provider!
      @worker.spin_up!
    end
    VCR.use_cassette(:worker_rip_down_destroy) do
      @worker.rip_down!
    end
    sleep(10) # need to sleep to let the host catch up... lol
  end
  
  it "should destroy the worker instance" do
    VCR.use_cassette(:worker_rip_down_retrieve_all) do
      worker_instances = case @worker.provider
        when "digital_ocean"
          DigitalOcean.droplet.all.droplets
      end
  
      expect(worker_instances).to_not include(a_hash_including(id: @worker.uid))
    end
  end
end

describe Worker, "#set_provider!" do
  before(:each) do
    @worker = build(:worker)
    @worker.set_provider!
  end

  it "should set the worker's provider" do
    expect(@worker.provider).to_not be_nil
  end
end
