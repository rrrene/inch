module Inch
  module Language
    module Nodejs
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
                fail NotImplementedError
              end

              def fullname
                fail NotImplementedError
              end

              def files
                fail NotImplementedError
              end

              def filename
                fail NotImplementedError
              end

              def children_fullnames
                fail NotImplementedError
              end

              def parent_fullname
                fail NotImplementedError
              end

              def api_tag?
                fail NotImplementedError
              end

              def aliased_object_fullname
                fail NotImplementedError
              end

              def aliases_fullnames
                fail NotImplementedError
              end

              def attributes
                fail NotImplementedError
              end

              def bang_name?
                fail NotImplementedError
              end

              def constant?
                fail NotImplementedError
              end

              def constructor?
                fail NotImplementedError
              end

              def depth
                fail NotImplementedError
              end

              def docstring
                fail NotImplementedError
              end

              def getter?
                fail NotImplementedError
              end

              def has_children?
                fail NotImplementedError
              end

              def has_code_example?
                fail NotImplementedError
              end

              def has_doc?
                fail NotImplementedError
              end

              def has_multiple_code_examples?
                fail NotImplementedError
              end

              def has_unconsidered_tags?
                fail NotImplementedError
              end

              def method?
                fail NotImplementedError
              end

              def nodoc?
                fail NotImplementedError
              end

              def namespace?
                fail NotImplementedError
              end

              def original_docstring
                fail NotImplementedError
              end

              def overridden?
                fail NotImplementedError
              end

              def overridden_method_fullname
                fail NotImplementedError
              end

              def parameters
                fail NotImplementedError
              end

              def private?
                fail NotImplementedError
              end

              def tagged_as_internal_api?
                fail NotImplementedError
              end

              def tagged_as_private?
                fail NotImplementedError
              end

              def protected?
                fail NotImplementedError
              end

              def public?
                fail NotImplementedError
              end

              def questioning_name?
                fail NotImplementedError
              end

              def return_described?
                fail NotImplementedError
              end

              def return_mentioned?
                fail NotImplementedError
              end

              def return_typed?
                fail NotImplementedError
              end

              def in_root?
                fail NotImplementedError
              end

              def setter?
                fail NotImplementedError
              end

              def source
                fail NotImplementedError
              end

              def unconsidered_tag_count
                fail NotImplementedError
              end

              def undocumented?
                fail NotImplementedError
              end

              def visibility
                fail NotImplementedError
              end
            end
          end
        end
      end
    end
  end
end
