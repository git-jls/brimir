class AddCatchMeUpToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :catch_me_up, :boolean, default: false, null: false
  end
end
