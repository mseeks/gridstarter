require "spec_helper"

# ---------------------------------------------------------
# Class Methods
# ---------------------------------------------------------

# ---------------------------------------------------------
# Instance Methods
# ---------------------------------------------------------

describe Task, "#complete?" do
  it "should return true if progress is 100%" do
    complete_task = create(:task, :complete)
    expect(complete_task.complete?).to be_truthy
  end
  
  it "should return false if progress is less 100%" do
    in_progress_task = create(:task, :in_progress)
    expect(in_progress_task.complete?).to be_falsey
  end
end
