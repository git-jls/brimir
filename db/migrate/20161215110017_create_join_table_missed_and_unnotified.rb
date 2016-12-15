class CreateJoinTableMissedAndUnnotified < ActiveRecord::Migration
  def change
    create_join_table :tickets, :users, table_name: :missed_and_unnotified do |t|
      # t.index [:ticket_id, :user_id]
      # t.index [:user_id, :ticket_id]
    end
  end
end
