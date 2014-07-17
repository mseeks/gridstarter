desc "Delete all VCR cassettes"
task :magnet => :environment do
  `rm -rf ./spec/vcr_cassettes/*`
end
