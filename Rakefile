require File.expand_path('../app'            , __FILE__)
require File.expand_path('../config/bot'     , __FILE__)
require File.expand_path('../config/database', __FILE__)

Dir.glob(File.expand_path('../task/*.rake', __FILE__)).each do |task|
  import(task)
end
