## Define all exceptions here
class XHandler < Exception
end

class ExistsException < XHandler
  def initialize( message )
    super( message )
  end
end
