module Inch
  module Evaluation
    module Ruby
      # Base class for all Ruby related evaluations
      #
      # @abstract
      class Base < Evaluation::Proxy
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
            Role::Object::WithoutCodeExample => score_for(:code_example_single),
            Role::Object::Tagged => score_for_unconsidered_tags,
            Role::Object::TaggedAsAPI => nil,
            Role::Object::TaggedAsInternalAPI => nil,
            Role::Object::TaggedAsPrivate => nil,
            Role::Object::Alias =>
              if object.alias?
                object.aliased_object.score
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
