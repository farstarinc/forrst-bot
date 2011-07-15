Sequel.migration do
  up do
    create_table(:notes) do
      primary_key :id

      String :channel, :null => false
      String :user   , :null => false
      String :author , :null => false
      String :note   , :text => true

      Time :created_at
    end
  end

  down do
    drop_table(:notes)
  end
end
