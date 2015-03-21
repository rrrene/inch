# One entry of a cross-reference section or stream.
#
# An entry has the attributes +type+, +oid+, +gen+, +pos+ and +objstm+ and can be created like
# this:
#
#   Entry.new(type, oid, gen, pos, objstm)   -> entry
#
# The +type+ attribute can be:
#
# :free:: Denotes a free entry.
#
# :in_use:: A used entry that resides in the body of the PDF file. The +pos+ attribute defines
#           the position in the file at which the object can be found.
#
# :compressed:: A used entry that resides in an object stream. The +objstm+ attribute contains
#               the reference to the object stream in which the object can be found and the
#               +pos+ attribute contains the index into the object stream.
#
#               Objects in an object stream always have a generation number of 0!
#
# See: PDF1.7 s7.5.4, s7.5.8
StructWithRDoc = Struct.new(:type, :oid, :gen, :pos, :objstm, :member_without_doc)

# One entry of a cross-reference section or stream.
#
# An entry has the attributes +type+, +oid+, +gen+, +pos+ and +objstm+ and can be created like
# this:
#
#   Entry.new(type, oid, gen, pos, objstm)   -> entry
#
# The +type+ attribute can be:
#
# :free:: Denotes a free entry.
#
# :in_use:: A used entry that resides in the body of the PDF file. The +pos+ attribute defines
#           the position in the file at which the object can be found.
#
# :compressed:: A used entry that resides in an object stream. The +objstm+ attribute contains
#               the reference to the object stream in which the object can be found and the
#               +pos+ attribute contains the index into the object stream.
#
#               Objects in an object stream always have a generation number of 0!
#
# See: PDF1.7 s7.5.4, s7.5.8
class StructWithRDocAsInheritedClass < Struct.new(:type, :oid, :gen, :pos, :objstm, :member_without_doc)
end

# Representation of attributes of a user in the database
#
# @!attribute email
#   @return [String] E-mail address (from Devise)
# @!attribute username
#   @return [String] Username (from Devise)
StructWithYardDirectivesOutside = Struct.new(:email, :username, :member_without_doc)

# Representation of attributes of a user in the database
#
class StructWithYardDirectivesAsInheritedClass < Struct.new(:email, :username, :member_without_doc)
  # @!attribute email
  #   @return [String] E-mail address (from Devise)
  # @!attribute username
  #   @return [String] Username (from Devise)
end

# Representation of attributes of a user in the database
#
# @!attribute email
#   @return [String] E-mail address (from Devise)
# @!attribute username
#   @return [String] Username (from Devise)
class StructWithYardDirectivesOutsideAsInheritedClass < Struct.new(:email, :username, :member_without_doc)
end
