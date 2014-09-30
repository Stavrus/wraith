after :teams, 'development:matches' do
  Mission.create({:title => 'Mission 1', :description => 'Mission 1 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 1, :match_id => 1})
  Mission.create({:title => 'Mission 2', :description => 'Mission 2 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 2, :match_id => 1})
  Mission.create({:title => 'Mission 3', :description => 'Mission 3 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 1, :match_id => 2})
  Mission.create({:title => 'Mission 4', :description => 'Mission 4 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 2, :match_id => 2})
  Mission.create({:title => 'Mission 5', :description => 'Mission 5 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 1, :match_id => 2})
  Mission.create({:title => 'Mission 6', :description => 'Mission 6 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 2, :match_id => 2})
  Mission.create({:title => 'Mission 7', :description => 'Mission 7 Description',
                  :date_release => DateTime.parse('2009-09-01 8:00'),
                  :team_id => 1, :match_id => 2})
end