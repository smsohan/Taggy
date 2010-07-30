Role.create(:name => 'Team') unless Role.exists?(:name => 'Team')
Role.create(:name => 'Customer') unless Role.exists?(:name => 'Customer')



