# Representation of attributes of a user in the database
#
# @!attribute email
#   @return [String] E-mail address (from Devise)
class Attributes
  # @return [String] Username (from Devise)
  attr_accessor :username
end


# Representation of attributes of a user in the database
#
class AttributesAccessor
  attr_accessor :username
  # @!attribute email
  #   @return [String] E-mail address (from Devise)
  attr_accessor :email
end


# Representation of attributes of a user in the database
#
class AttributesStruct < Struct.new(:email, :username)
  # @!attribute email
  #   @return [String] E-mail address (from Devise)
  # @!attribute username
  #   @return [String] Username (from Devise)
end

