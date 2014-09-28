require 'inch/language/nodejs/provider/jsdoc/docstring'
require 'inch/utils/code_location'

module Inch
  module Language
    module Nodejs
      module Provider
        module JSDoc
          module Object
            # @abstract
            class Base
              # @return [String] the codebase's directory
              attr_accessor :base_dir

              # @param hash [Hash] hash returned via JSON interface
              def initialize(hash)
                @hash = hash
              end

              def name
                @hash['name']
              end

              def fullname
                #fail NotImplementedError
                base = "#{@hash['longname']}"
                if meta?
                  base << " @ #{meta['path']}/" \
                          "#{meta['filename']}:" \
                          "#{meta['lineno']}"
                end
                base
              end

              # Returns all files declaring the object in the form of an Array
              # of Arrays containing the location of their declaration.
              #
              # @return [Array<CodeLocation>]
              def files
                return [] unless meta?
                filename = meta['path'] + '/' + meta['filename']
                [
                  Inch::Utils::CodeLocation.new('', filename, meta['lineno'])
                ]
              end

              def filename
                files.first.filename unless files.empty?
              end

              attr_writer :children_fullnames
              def children_fullnames
                @children_fullnames ||= []
              end

              def parent_fullname
                if depth == 1
                  nil
                else
                  fullname.split('.')[0...-1].join('.')
                end
              end

              def api_tag?
                nil
              end

              def aliased_object_fullname
                nil
              end

              def aliases_fullnames
                nil
              end

              def attributes
                []
              end

              def bang_name?
                false
              end

              def constant?
                false # raise NotImplementedError
              end

              def constructor?
                false
              end

              def depth
                fullname.split('.').size
              end

              # @return [Docstring]
              def docstring
                @docstring ||= Docstring.new(@hash['comment'])
              end

              def getter?
                name =~ /^get_/ # raise NotImplementedError
              end

              def has_children?
                !children_fullnames.empty?
              end

              def has_code_example?
                false # raise NotImplementedError
              end

              def has_doc?
                !undocumented?
              end

              def has_multiple_code_examples?
                false # raise NotImplementedError
              end

              def has_unconsidered_tags?
                false # raise NotImplementedError
              end

              def method?
                false
              end

              def nodoc?
                @hash['comment'] == false
              end

              def namespace?
                false
              end

              def original_docstring
                @hash['comment']
              end

              def overridden?
                false # raise NotImplementedError
              end

              def overridden_method_fullname
                nil # raise NotImplementedError
              end

              def parameters
                if meta? && meta['code']
                  names = meta['code']['paramnames'] || []
                  names.map do |name|
                    FunctionParameterObject.new(self, name)
                  end
                else
                  []
                end
              end

              def private?
                false
              end

              def tagged_as_internal_api?
                false
              end

              def tagged_as_private?
                nodoc?
              end

              def protected?
                false
              end

              def public?
                true
              end

              def questioning_name?
                fullname =~ /\?$/
              end

              def return_described?
                false # raise NotImplementedError
              end

              def return_mentioned?
                false # raise NotImplementedError
              end

              def return_typed?
                false # raise NotImplementedError
              end

              def in_root?
                depth == 1
              end

              def setter?
                name =~ /^set_/ # raise NotImplementedError
              end

              def source
                nil
              end

              def unconsidered_tag_count
                0
              end

              def undocumented?
                @hash['comment'].to_s.empty?
              end

              def visibility
                docstring.visibility
              end

              protected

              def meta?
                !meta.nil?
              end

              def meta
                @hash['meta']
              end
            end
          end
        end
      end
    end
  end
end
