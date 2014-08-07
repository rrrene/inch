module Inch
  module CodeObject
    module Provider
      module JSDoc
        module Object
          # @abstract
          class Base
            # @param hash [Hash] hash returned via JSON interface
            def initialize(hash)
              @hash = hash
            end

            def name
              raise NotImplementedError
            end

            def fullname
              raise NotImplementedError
            end

            def files
              raise NotImplementedError
            end

            def filename
              raise NotImplementedError
            end

            def children_fullnames
              raise NotImplementedError
            end

            def parent_fullname
              raise NotImplementedError
            end

            def api_tag?
              raise NotImplementedError
            end

            def aliased_object_fullname
              raise NotImplementedError
            end

            def aliases_fullnames
              raise NotImplementedError
            end

            def attributes
              raise NotImplementedError
            end

            def bang_name?
              raise NotImplementedError
            end

            def constant?
              raise NotImplementedError
            end

            def constructor?
              raise NotImplementedError
            end

            def depth
              raise NotImplementedError
            end

            def docstring
              raise NotImplementedError
            end

            def getter?
              raise NotImplementedError
            end

            def has_children?
              raise NotImplementedError
            end

            def has_code_example?
              raise NotImplementedError
            end

            def has_doc?
              raise NotImplementedError
            end

            def has_multiple_code_examples?
              raise NotImplementedError
            end

            def has_unconsidered_tags?
              raise NotImplementedError
            end

            def method?
              raise NotImplementedError
            end

            def nodoc?
              raise NotImplementedError
            end

            def namespace?
              raise NotImplementedError
            end

            def original_docstring
              raise NotImplementedError
            end

            def overridden?
              raise NotImplementedError
            end

            def overridden_method_fullname
              raise NotImplementedError
            end

            def parameters
              raise NotImplementedError
            end

            def private?
              raise NotImplementedError
            end

            def tagged_as_internal_api?
              raise NotImplementedError
            end

            def tagged_as_private?
              raise NotImplementedError
            end

            def protected?
              raise NotImplementedError
            end

            def public?
              raise NotImplementedError
            end

            def questioning_name?
              raise NotImplementedError
            end

            def return_described?
              raise NotImplementedError
            end

            def return_mentioned?
              raise NotImplementedError
            end

            def return_typed?
              raise NotImplementedError
            end

            def in_root?
              raise NotImplementedError
            end

            def setter?
              raise NotImplementedError
            end

            def source
              raise NotImplementedError
            end

            def unconsidered_tag_count
              raise NotImplementedError
            end

            def undocumented?
              raise NotImplementedError
            end

            def visibility
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
