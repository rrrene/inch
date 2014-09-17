module Inch
  module Language
    module Ruby
      module Evaluation
        # Base class for all Ruby related evaluations
        #
        # @abstract
        class Base < Inch::Evaluation::Proxy
          protected

          def relevant_base_roles
            {
              Role::Object::InRoot => nil,
              Role::Object::Public => nil,
              Role::Object::Protected => nil,
              Role::Object::Private => nil,
              Role::Object::TaggedAsNodoc => nil,
              Role::Object::WithDoc => score_for(:docstring),
              Role::Object::WithoutDoc => score_for(:docstring),
              Role::Object::WithCodeExample => score_for(:code_example_single),
              Role::Object::WithMultipleCodeExamples =>
                score_for(:code_example_multi),
              Role::Object::WithoutCodeExample =>
                score_for(:code_example_single),
              Role::Object::Tagged => score_for_unconsidered_tags,
              Role::Object::TaggedAsAPI => nil,
              Role::Object::TaggedAsInternalAPI => nil,
              Role::Object::TaggedAsPrivate => nil,
              Role::Object::Alias =>
                if object.alias?
                  aliased_object = object.aliased_object
                  if aliased_object.alias? && aliased_object.aliased_object.alias?
                    # warn "Possible alias cycle: #{object.fullname} -> #{aliased_object.fullname}"
                    nil
                  else
                    aliased_object.score
                  end
                else
                  nil
                end
            }
          end

          def score_for_unconsidered_tags
            count = object.unconsidered_tag_count
            score_for(:unconsidered_tag) * count
          end
        end
      end
    end
  end
end
