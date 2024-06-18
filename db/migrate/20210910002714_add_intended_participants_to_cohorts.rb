class AddIntendedParticipantsToCohorts < ActiveRecord::Migration[6.1]
  def change
    add_column :cohorts, :intended_participants_hs, :integer
    add_column :cohorts, :intended_participants_ms, :integer
  end
end
