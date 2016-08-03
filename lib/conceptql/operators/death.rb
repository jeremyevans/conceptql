require_relative 'casting_operator'

module ConceptQL
  module Operators
    class Death < CastingOperator
      register __FILE__

      desc 'Generates all death records, or, if fed a stream, fetches all death records for the people represented in the incoming result set.'
      domains :death
      allows_one_upstream

      def my_domain
        :death
      end

      def source_table
        if oi_cdm?
          :deaths
        else
          :death
        end
      end

      def i_point_at
        [ :person ]
      end

      def these_point_at_me
        []
      end
    end
  end
end
