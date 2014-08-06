module Inch
  module CodeObject
    # The Converter takes code object representations from a provider and
    # converts them into attributes hashes.
    # These attributes can then be used to initialize a CodeObject::Proxy.
    #
    # @see CodeObject::Proxy.for
    module Converter
      OBJECT_ATTRIBUTES = %w(
        name
        fullname
        files
        filename

        children_fullnames
        parent_fullname

        api_tag?
        aliased_object_fullname
        aliases_fullnames
        attributes
        bang_name?
        constant?
        constructor?
        depth
        docstring
        getter?
        has_children?
        has_code_example?
        has_doc?
        has_multiple_code_examples?
        has_unconsidered_tags?
        method?
        nodoc?
        namespace?
        original_docstring
        overridden?
        overridden_method_fullname
        parameters
        private?
        tagged_as_internal_api?
        tagged_as_private?
        protected?
        public?
        questioning_name?
        return_described?
        return_mentioned?
        return_typed?
        in_root?
        setter?
        source
        unconsidered_tag_count
        undocumented?
        visibility
      ).map(&:to_sym)

      PARAMETER_ATTRIBUTES = %w(
        name
        block?
        described?
        mentioned?
        splat?
        typed?
        wrongly_mentioned?
      ).map(&:to_sym)

      # Returns an attributes Hash for a given code object
      #
      # @param o [Provider::YARD::Object::Base]
      # @return [Hash]
      def self.to_hash(o)
        attributes = {}
        OBJECT_ATTRIBUTES.each do |name|
          next unless o.respond_to?(name)
          attributes[name] = o.public_send(name)
        end
        attributes[:parameters] = o.parameters.map do |parameter|
          hash = {}
          PARAMETER_ATTRIBUTES.each do |pname|
            next unless parameter.respond_to?(pname)
            hash[pname] = parameter.public_send(pname)
          end
          hash
        end
        attributes
      end
    end
  end
end
