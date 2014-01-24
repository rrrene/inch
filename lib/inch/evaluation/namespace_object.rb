module Inch
  module Evaluation
    # a namespace object can have methods and other namespace objects
    # inside itself (e.g. classes and modules)
    class NamespaceObject < Base
      DOC_SCORE = MAX_SCORE
      EXAMPLE_SCORE = 10
      MULTIPLE_EXAMPLES_SCORE = 20

      RUBY_CORE = %w(Array Bignum BasicObject Object Module Class Complex NilClass Numeric String Float Fiber FiberError Continuation Dir File Encoding Enumerator StopIteration Enumerator::Generator Enumerator::Yielder Exception SystemExit SignalException Interrupt StandardError TypeError ArgumentError IndexError KeyError RangeError ScriptError SyntaxError LoadError NotImplementedError NameError NoMethodError RuntimeError SecurityError NoMemoryError EncodingError SystemCallError Encoding::CompatibilityError File::Stat IO Hash ENV IOError EOFError ARGF RubyVM RubyVM::InstructionSequence Math::DomainError ZeroDivisionError FloatDomainError Integer Fixnum Data TrueClass FalseClass Mutex Thread Proc LocalJumpError SystemStackError Method UnboundMethod Binding Process::Status Random Range Rational RegexpError Regexp MatchData Symbol Struct ThreadGroup ThreadError Time Encoding::UndefinedConversionError Encoding::InvalidByteSequenceError Encoding::ConverterNotFoundError Encoding::Converter RubyVM::Env) +
                  %w(Comparable Kernel File::Constants Enumerable Errno FileTest GC ObjectSpace GC::Profiler IO::WaitReadable IO::WaitWritable Marshal Math Process Process::UID Process::GID Process::Sys Signal)

      def evaluate
        eval_doc
        eval_children
        eval_code_example

        if object.has_many_attributes?
          add_role Role::Namespace::WithManyAttributes.new(object)
        end
        if object.nodoc?
          add_role Role::Object::TaggedAsNodoc.new(object)
        end
        if object.has_unconsidered_tags?
          count = object.unconsidered_tags.size
          add_role Role::Object::Tagged.new(object, TAGGED_SCORE * count)
        end
        if object.in_root?
          add_role Role::Object::InRoot.new(object)
        end
        if object.public?
          add_role Role::Object::Public.new(object)
        end
        if object.protected?
          add_role Role::Object::Protected.new(object)
        end
        if object.private?
          add_role Role::Object::Private.new(object)
        end

        eval_core
      end

      private

      def eval_core
        if RUBY_CORE.include?(object.path)
          add_role Role::Namespace::Core.new(object)
        end
      end

      def eval_doc
        if object.has_doc?
          add_role Role::Object::WithDoc.new(object, DOC_SCORE)
        else
          add_role Role::Object::WithoutDoc.new(object, DOC_SCORE)
        end
      end

      def eval_code_example
        if object.has_code_example?
          if object.has_multiple_code_examples?
            add_role Role::Object::WithMultipleCodeExamples.new(object, MULTIPLE_EXAMPLES_SCORE)
          else
            add_role Role::Object::WithCodeExample.new(object, EXAMPLE_SCORE)
          end
        else
          add_role Role::Object::WithoutCodeExample.new(object, EXAMPLE_SCORE)
        end
      end

      def eval_children
        if children.empty?
          add_role Role::Namespace::WithoutChildren.new(object)
        else
          add_role Role::Namespace::WithChildren.new(object, children.map(&:score).min)
          if object.pure_namespace?
            add_role Role::Namespace::Pure.new(object)
          end
          if object.no_methods?
            add_role Role::Namespace::WithoutMethods.new(object)
          end
          if object.has_many_children?
            add_role Role::Namespace::WithManyChildren.new(object)
          end
        end
      end

      def children
        @children ||= object.children.map(&:evaluation)
      end
    end
  end
end
