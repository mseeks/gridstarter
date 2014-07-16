require "spec_helper"

# ---------------------------------------------------------
# Class Methods
# ---------------------------------------------------------

# ---------------------------------------------------------
# Instance Methods
# ---------------------------------------------------------

describe Worker, "#spin_up!" do
  before(:all) do
    VCR.use_cassette(:worker_spin_up_create) do
      @worker = create(:worker)
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
    sleep(60)
    VCR.use_cassette(:worker_spin_up_destroy) do
      @worker.rip_down!
    end
  end
end

describe Worker, "#rip_down!" do
  before(:all) do
    VCR.use_cassette(:worker_rip_down_create) do
      @worker = create(:worker)
      @worker.spin_up!
    end
    sleep(60)
    VCR.use_cassette(:worker_rip_down_destroy) do
      @worker.rip_down!
    end
    sleep(60)
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
