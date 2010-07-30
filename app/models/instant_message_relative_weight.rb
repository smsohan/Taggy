class InstantMessageRelativeWeight < RelativeWeight
    
  def self.instance
    self.first || create
  end
    
end