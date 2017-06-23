require_relative 'operator'

module ConceptQL
  module Operators
    # Base class for all operators that take two streams, a left-hand and a right-hand
    class BinaryOperatorOperator < Operator
      option :left, type: :upstream
      option :right, type: :upstream
      validate_no_arguments
      validate_option Array, :left, :right
      validate_required_options :left, :right
      category "Filter by Comparing"
      basic_type :filter

      def upstreams
        [left]
      end

      def code_list(db)
        left.code_list(db) + right.code_list(db)
      end

      attr :left, :right

      private

      def annotate_values(db, opts = {})
        h = {}
        h[:left] = left.annotate(db, opts) if left
        h[:right] = right.annotate(db, opts) if right
        [options.merge(h), *arguments]
      end

      def create_upstreams
        @left = to_op(options[:left]) if options[:left].is_a?(Array)
        @right = to_op(options[:right])  if options[:right].is_a?(Array)
      end
    end
  end
end
