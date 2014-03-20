module Inch
  module CodeObject
    module Provider
      module YARD
        module Object
          # Proxy class for methods
          class MethodObject < Base
            def aliases_fullnames
              object.aliases.map(&:path)
            end

            def bang_name?
              name =~ /\!$/
            end

            def constructor?
              name == :initialize
            end

            def getter?
              attr_info = object.attr_info || {}
              read_info = attr_info[:read]
              if read_info
                read_info.path == fullname
              else
                parent.child(:"#{name}=")
              end
            end

            def has_doc?
              super && !implicit_docstring?
            end

            def method?
              true
            end

            def overloaded?
            end

            def parameters
              @parameters ||= all_parameter_names.map do |name|
                signature_name = in_signature(name)
                tag = parameter_tag(name) || parameter_tag(signature_name) ||
                        overload_tag_with_parameter(name)

                MethodParameterObject.new(self, name, signature_name, tag)
              end
            end

            def parameter(name)
              parameters.detect { |p| p.name == name.to_s }
            end

            def overridden?
              !!object.overridden_method
            end

            def overridden_method
              return unless overridden?
              @overridden_method ||= YARD::Object.for(object.overridden_method)
            end

            def overridden_method_fullname
              return unless overridden?
              overridden_method.fullname
            end

            def return_mentioned?
              !!return_tag || docstring.mentions_return?
            end

            def return_described?
              (return_tag && !return_tag.text.empty?) || docstring.describes_return?
            end

            def return_typed?
              return_mentioned?
            end

            def setter?
              name =~ /\=$/ && parameters.size == 1
            end

            def questioning_name?
              name =~ /\?$/
            end

            private

            def all_parameter_names
              names = signature_parameter_names
              names.concat parameter_tags.map(&:name)
              names.compact.map { |name| name.gsub(/[\*\&]/, '') }.uniq
            end

            def implicit_docstring?
              if getter?
                docstring == "Returns the value of attribute #{name}"
              elsif setter?
                basename = name.to_s.gsub(/(\=)$/, '')
                docstring == "Sets the attribute #{basename}"
              else
                false
              end
            end

            def in_signature(name)
              possible_names = [name, "*#{name}", "&#{name}"]
              (signature_parameter_names & possible_names).first
            end

            def normalize_parameter_name(name)
              # remove leading and trailing brackets
              # (sometimes used to indicate optional parameters in overload
              # signatures)
              name.gsub(/[\[\]]/, '')
            end

            def overload_tags
              object.tags(:overload)
            end

            # Returns all parameter names from all overload signatures.
            # @todo analyse each signature on its own
            def overloaded_parameter_names
              overload_tags.map do |tag|
                tag.parameters.map do |parameter|
                  normalize_parameter_name(parameter[0])
                end
              end.flatten
            end

            def overload_tag_with_parameter(name)
              overload_tags.detect do |tag|
                tag.parameters.map(&:first).include?(name)
              end
            end

            def signature_parameter_names
              object.parameters.map(&:first) + overloaded_parameter_names
            end

            def parameter_tag(param_name)
              parameter_tags.detect do |tag|
                tag.name == param_name
              end
            end

            def parameter_tags
              object.tags(:param)
            end

            def return_tag
              object.tags(:return).first
            end
          end
        end
      end
    end
  end
end
