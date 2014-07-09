require "spec_helper"

feature "User visits home page" do

  it "has the welcome message" do
    visit root_path
    page.should have_content "Welcome to Boink"
  end

end
