module Inch
  module CodeObject
    module Converter
      ATTRIBUTES = %w(
        api_tag?
        attributes
        bang_name?
        constant?
        constructor?
        docstring
        files
        getter?
        has_alias?
        has_children?
        has_code_example?
        has_doc?
        has_multiple_code_examples?
        has_unconsidered_tags?
        method?
        namespace?
        overridden?
        parameters
        private?
        private_api_tag?
        private_tag?
        protected?
        public?
        questioning_name?
        return_described?
        return_mentioned?
        return_typed?
        in_root?
        setter?
        source
        unconsidered_tags?
        undocumented?
        ).map(&:to_sym)

      def self.to_hash(o)
        attributes = {}
        ATTRIBUTES.each do |name|
          if o.respond_to?(name)
            attributes[name] = o.method(name).call
          end
        end
        attributes
      end
    end
  end
end
