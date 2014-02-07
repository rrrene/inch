module Inch
  module Evaluation
    # a namespace object can have methods and other namespace objects
    # inside itself (e.g. classes and modules)
    class NamespaceObject < Base
      RUBY_CORE = %w(Array Bignum BasicObject Object Module Class Complex NilClass Numeric String Float Fiber FiberError Continuation Dir File Encoding Enumerator StopIteration Enumerator::Generator Enumerator::Yielder Exception SystemExit SignalException Interrupt StandardError TypeError ArgumentError IndexError KeyError RangeError ScriptError SyntaxError LoadError NotImplementedError NameError NoMethodError RuntimeError SecurityError NoMemoryError EncodingError SystemCallError Encoding::CompatibilityError File::Stat IO Hash ENV IOError EOFError ARGF RubyVM RubyVM::InstructionSequence Math::DomainError ZeroDivisionError FloatDomainError Integer Fixnum Data TrueClass FalseClass Mutex Thread Proc LocalJumpError SystemStackError Method UnboundMethod Binding Process::Status Random Range Rational RegexpError Regexp MatchData Symbol Struct ThreadGroup ThreadError Time Encoding::UndefinedConversionError Encoding::InvalidByteSequenceError Encoding::ConverterNotFoundError Encoding::Converter RubyVM::Env) +
                  %w(Comparable Kernel File::Constants Enumerable Errno FileTest GC ObjectSpace GC::Profiler IO::WaitReadable IO::WaitWritable Marshal Math Process Process::UID Process::GID Process::Sys Signal)

      def evaluate
        eval_doc
        eval_code_example
        eval_visibility
        eval_tags
        
        eval_children
        eval_namespace
      end

      private

      def eval_namespace
        if RUBY_CORE.include?(object.path)
          add_role Role::Namespace::Core.new(object)
        end
        if object.has_many_attributes?
          add_role Role::Namespace::WithManyAttributes.new(object)
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
