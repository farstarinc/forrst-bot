##
# Configuration file used to specify the details of the database the bot should
# connect to. This database is used for storing notes, URLs and various other
# things.
#
ForrstBot.database = Sequel.connect(
  :adapter  => 'sqlite',
  :database => File.expand_path('../../database.db', __FILE__),
  :test     => true,
  :encoding => 'utf8'
)

# IMPORTANT, when running MySQL the engine should be set to InnoDB in order for 
# foreign keys to work properly.
if ForrstBot.database.adapter_scheme.to_s.include?('mysql')
  Sequel::MySQL.default_engine = 'InnoDB'
end

