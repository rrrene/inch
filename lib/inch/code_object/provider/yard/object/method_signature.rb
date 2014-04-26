module Inch
  module CodeObject
    module Provider
      module YARD
        module Object
          # Utility class to describe (overloaded) method signatures
          class MethodSignature < Struct.new(:method, :yard_tag)
            attr_reader :method, :yard_tag

            # @param method [Provider::YARD::Object::MethodObject]
            # @param method [::YARD::Tags::Tag,nil] if nil, the method's normal signature is used
            def initialize(method, yard_tag = nil)
              @method = method
              @yard_tag = yard_tag
            end

            def all_signature_parameter_names
              if tag?
                yard_tag.parameters.map(&:first)
              else
                yard_object.parameters.map(&:first)
              end
            end

            def has_code_example?
              if tag?
                !yard_tag.tags(:example).empty?
              else
                !yard_object.tags(:example).empty?
              end
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

            # Returns +true+ if the other signature is identical to self
            # @param other [MethodSignature]
            # @return [Boolean]
            def same?(other)
              all_signature_parameter_names == other.all_signature_parameter_names
            end

            # Returns the actual signature of the method.
            # @return [String]
            def signature
              if tag?
                yard_tag.signature
              else
                yard_object.signature.gsub(/^(def\ )/, '')
              end
            end

            private

            def all_parameter_names
              all_names = all_signature_parameter_names + parameter_tags.map(&:name)
              all_names.map do |name|
                normalize_parameter_name(name) if name
              end.compact.uniq
            end

            def docstring
              if tag?
                yard_tag.docstring
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
                @yard_tag.tags(:param)
              else
                yard_object.tags(:param)
              end
            end

            def tag?
              !yard_tag.nil?
            end

            def yard_object
              method.object
            end
          end
        end
      end
    end
  end
end
