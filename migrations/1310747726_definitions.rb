Sequel.migration do
  up do
    create_table(:definitions) do
      primary_key :id

      String :name   , :null => false, :unique => true
      String :value  , :null => false, :text   => true
      String :author , :null => false
      String :channel, :null => false

      Time :created_at
    end 
  end
  
  down do
    drop_table(:definitions)
  end
end
