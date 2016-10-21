require_relative 'temporal_operator'

module ConceptQL
  module Operators
    class Equal < TemporalOperator
      register __FILE__

      desc 'If a result in the left hand results (LHR) has the same value_as_number as a result in the right hand results (RHR), it is passed through.'
      require_column :value_as_number

      def where_clause
        { r__value_as_number: :l__value_as_number }
      end
    end
  end
end
