module Inch
  module CodeObject
    module Provider
      module YARD
        module Object
          # Utility class to describe (overloaded) method signatures
          class MethodSignature < Struct.new(:method, :tag_or_method)
            def has_code_example?
              !yard_object.tags(:example).empty?
            end

            def has_doc?
              !docstring.empty?
            end

            def parameters
              @parameters ||= all_parameter_names.map do |name|
                signature_name = in_signature(name)
                tag = parameter_tag(name) || parameter_tag(signature_name)
                MethodParameterObject.new(method, name, signature_name, tag)
              end
            end

            def parameter(name)
              parameters.detect { |p| p.name == name.to_s }
            end

            # Returns the actual signature of the method.
            # @return [String]
            def signature
              if tag?
                tag_or_method.signature
              else
                yard_object.signature.gsub(/^(def\ )/, '')
              end
            end

            #private

            def all_parameter_names
              all_names = all_signature_parameter_names + parameter_tags.map(&:name)
              all_names.map do |name|
                normalize_parameter_name(name) if name
              end.compact.uniq
            end

            def all_signature_parameter_names
              if tag?
                tag_or_method.parameters.map(&:first)
              else
                yard_object.parameters.map(&:first)
              end
            end

            def docstring
              if tag?
                tag_or_method.docstring
              else
                yard_object.docstring
              end
            end

            # Returns how the given parameter is noted in the method's
            # signature.
            #
            # @param name [String] parameter name
            # @return [String]
            def in_signature(name)
              possible_names = [name, "*#{name}", "&#{name}"]
              (all_signature_parameter_names & possible_names).first
            end

            # Removes block, splat symbols, dollar sign,
            # leading and trailing brackets from a given +name+
            # (sometimes used to indicate optional parameters in overload
            # signatures).
            # @param name [String] parameter name
            # @return [String]
            def normalize_parameter_name(name)
              name.gsub(/[\&\*\$\[\]]/, '')
            end

            def parameter_tag(param_name)
              parameter_tags.detect do |tag|
                tag.name == param_name
              end
            end

            def parameter_tags
              if tag?
                tag_or_method.tags(:param)
              else
                yard_object.tags(:param)
              end
            end

            def tag?
              tag_or_method.respond_to?(:signature)
            end

            def yard_object
              tag_or_method.object
            end
          end
        end
      end
    end
  end
end
