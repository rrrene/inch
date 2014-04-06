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
              super && !implicit_docstring? || overload_tags.any? { |t| !t.docstring.empty? }
            end

            def method?
              true
            end

            def parameters
              @parameters ||= all_parameter_names.map do |name|
                signature_name = in_signature(name)
                tag = parameter_tag(name) || parameter_tag(signature_name) ||
                        param_tag_in_overload_tags(name) ||
                        param_tag_in_overload_tags(signature_name)
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
              !return_tags.empty? || docstring.mentions_return?
            end

            def return_described?
              return_tags.any? { |t| !t.text.empty? } ||
                docstring.describes_return?
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
                Array(tag.parameters).map do |parameter|
                  normalize_parameter_name(parameter[0])
                end
              end.flatten
            end

            def param_tag_in_overload_tags(name)
              overload_tags.map do |overload_tag|
                find_param_tag(overload_tag, name)
              end.first
            end

            def find_param_tag(overload_tag, name)
              overload_tag.tags(:param).detect do |param_tag|
                param_tag.name == name
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

            def return_tags
              object.tags(:return) + overloaded_return_tags
            end

            def overloaded_return_tags
              overload_tags.map do |overload_tag|
                overload_tag.tag(:return)
              end.compact
            end
          end
        end
      end
    end
  end
end
