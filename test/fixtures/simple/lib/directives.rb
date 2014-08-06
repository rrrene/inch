# Representation of attributes of a user in the database
#
# @!attribute email
#   @return [String] E-mail address (from Devise)
class Attributes
  # @return [String] Username (from Devise)
  attr_accessor :username
end
