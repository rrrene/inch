require 'forwardable'
require 'inch/utils/code_location'

module Inch
  module Language
    module Ruby
      module Provider
        module YARD
          module Object
            # @abstract
            class Base
              extend Forwardable
              include YARD::NodocHelper

              # @return [YARD::CodeObjects::Base] the actual (YARD) code object
              attr_reader :object

              # @return [String] the codebase's directory
              attr_accessor :base_dir

              # Tags considered by wrapper methods like {#has_code_example?}
              CONSIDERED_YARD_TAGS = %w(api example param private return since)
              AUTO_GENERATED_TAG_NAMES = %w(raise yield)

              # convenient shortcuts to (YARD) code object
              def_delegators :object,
                             :type, :namespace, :source, :source_type, :group,
                             :dynamic, :visibility

              # @param object [YARD::CodeObjects::Base] the actual (YARD) code
              #   object
              def initialize(object)
                @object = object
                @api_tag = __api_tag
                @parent = __parent
                @private_tag = __private_tag
              end

              # Returns the fullname of the object that the current object
              # is an alias for
              attr_accessor :aliased_object_fullname

              # Returns the fullnames of the objects that are aliases
              # for the current object
              def aliases_fullnames
                []
              end

              def api_tag?
                !api_tag.nil?
              end

              attr_reader :api_tag

              # To be overridden
              # @see Proxy::NamespaceObject
              # @return [CodeObject::Proxy,nil] the child inside the current
              #   object or +nil+
              def child(_name)
                nil
              end

              # @return [Array,nil] the full names of the children of the
              #   current object
              def children_fullnames
                []
              end

              # To be overridden
              # @see Proxy::NamespaceObject
              def children
                []
              end

              RUBY_CORE = %w(
                Array Bignum BasicObject Object Module Class Complex NilClass
                Numeric String Float Fiber FiberError Continuation Dir File
                Encoding Enumerator StopIteration Enumerator::Generator
                Enumerator::Yielder Exception SystemExit SignalException
                Interrupt StandardError TypeError ArgumentError IndexError
                KeyError RangeError ScriptError SyntaxError LoadError
                NotImplementedError NameError NoMethodError RuntimeError
                SecurityError NoMemoryError EncodingError SystemCallError
                Encoding::CompatibilityError
                File::Stat IO Hash ENV IOError EOFError ARGF RubyVM
                RubyVM::InstructionSequence Math::DomainError ZeroDivisionError
                FloatDomainError Integer Fixnum Data TrueClass FalseClass Mutex
                Thread Proc LocalJumpError SystemStackError Method UnboundMethod
                Binding Process::Status Random Range Rational RegexpError Regexp
                MatchData Symbol Struct ThreadGroup ThreadError Time
                Encoding::UndefinedConversionError
                Encoding::InvalidByteSequenceError
                Encoding::ConverterNotFoundError Encoding::Converter RubyVM::Env

                Comparable Kernel File::Constants Enumerable Errno FileTest GC
                ObjectSpace GC::Profiler IO::WaitReadable IO::WaitWritable
                Marshal Math Process Process::UID Process::GID Process::Sys
                Signal
              )
              def core?
                RUBY_CORE.include?(name.to_s)
              end

              # @return [Docstring]
              def docstring
                @docstring ||= Docstring.new(object.docstring)
              end

              # Returns all files declaring the object in the form of an Array
              # of Arrays containing the location of their declaration.
              #
              # @return [Array<CodeLocation>]
              def files
                object.files.map do |(filename, line_no)|
                  Inch::Utils::CodeLocation.new(base_dir, filename, line_no)
                end
              rescue ::YARD::CodeObjects::ProxyMethodError
                # this error is raised by YARD
                # see broken.rb in test fixtures
                []
              end

              # Returns the name of the file where the object is declared first
              # @return [String] a filename
              def filename
                # just checking the first file (which is the file where an
                # object is first declared)
                files.first && files.first.filename
              end

              def fullname
                @fullname ||= object.path
              end

              def name
                @name ||= object.name
              end

              def has_children?
                !children.empty?
              end

              def has_code_example?
                !tags(:example).empty? ||
                  docstring.contains_code_example?
              end

              def has_doc?
                !docstring.empty?
              end

              def has_multiple_code_examples?
                if tags(:example).size > 1 || docstring.code_examples.size > 1
                  true
                else
                  if (tag = tag(:example))
                    multi_code_examples?(tag.text)
                  elsif (text = docstring.code_examples.first)
                    multi_code_examples?(text)
                  else
                    false
                  end
                end
              end

              def has_unconsidered_tags?
                !unconsidered_tags.empty?
              end

              def in_root?
                depth == 1
              end

              # The depth of the following is 4:
              #
              #   Foo::Bar::Baz#initialize
              #    ^    ^    ^      ^
              #    1 << 2 << 3  <<  4
              #
              # +depth+ answers the question "how many layers of code objects
              # are above this one?"
              #
              # @note top-level counts, that's why Foo has depth 1!
              #
              # @return [Fixnum] the depth of the object in terms of namespace
              def depth
                @__depth ||= __depth
              end

              # @return [Boolean] +true+ if the object represents a method
              def method?
                false
              end

              # @return [Boolean] +true+ if the object represents a namespace
              def namespace?
                false
              end

              # @return [String] the documentation comments
              def original_docstring
                object.docstring.all.to_s
              end

              def parameters
                []
              end

              # @return [Array,nil] the parent of the current object or +nil+
              attr_reader :parent

              def __parent
                YARD::Object.for(object.parent) if object.parent
              end

              def private?
                visibility == :private
              end

              def tagged_as_internal_api?
                private_api_tag? || docstring.describes_internal_api?
              end

              def tagged_as_private?
                private_tag? || docstring.describes_private_object?
              end

              def protected?
                visibility == :protected
              end

              def public?
                visibility == :public
              end

              def in_root?
                depth == 1
              end

              # @return [Boolean] +true+ if the object has no documentation at
              #   all
              def undocumented?
                original_docstring.empty?
              end

              def unconsidered_tag_count
                unconsidered_tags.size
              end

              def inspect
                "#<#{self.class}: #{fullname}>"
              end

              protected

              def multi_code_examples?(text)
                text.scan(/\b(#{Regexp.escape(name)})[^_0-9\!\?]/m).size > 1
              end

              # @return [Boolean]
              #   +true+ if the object or its parent is tagged as @private
              def private_tag?
                !private_tag.nil?
              end

              attr_reader :private_tag

              def private_api_tag?
                api_tag && api_tag.text == 'private'
              end

              def tag(name)
                tags(name).first
              end

              def tags(name = nil)
                object.tags(name)
              rescue ::YARD::CodeObjects::ProxyMethodError
                # this error is raised by YARD
                # see broken.rb in test fixtures
                []
              end

              # @return [Array]
              #   YARD tags that are not already covered by other wrapper
              #   methods
              def unconsidered_tags
                @unconsidered_tags ||= tags.reject do |tag|
                  auto_generated_tag?(tag) ||
                    CONSIDERED_YARD_TAGS.include?(tag.tag_name)
                end
              end

              def __depth(i = 0)
                if parent
                  parent.__depth(i + 1)
                else
                  i
                end
              end

              private

              def __api_tag
                tag(:api) || (parent && parent.api_tag)
              end

              def __private_tag
                tag(:private) || (parent && parent.private_tag)
              end

              def auto_generated_tag?(tag)
                tag.text.to_s.empty? &&
                  AUTO_GENERATED_TAG_NAMES.include?(tag.tag_name)
              end
            end
          end
        end
      end
    end
  end
end
