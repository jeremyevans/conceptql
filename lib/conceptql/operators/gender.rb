require_relative 'operator'

module ConceptQL
  module Operators
    class Gender < Operator
      register __FILE__

      desc 'Returns all person records that match the selected gender.'
      argument :gender, type: :string, options: ['Male', 'Female']
      domains :person
      category "Select by Property"
      basic_type :selection
      validate_no_upstreams
      validate_at_least_one_argument

      def query(db)
        gender_concept_ids = arguments.map do |value|
          case value.to_s
          when /^m/i
            8507
          when /^f/i
            8532
          else
            value.to_i
          end
        end

        db.from(table)
          .where(gender_concept_id: gender_concept_ids)
      end

      def query_cols
        dm.table_columns(table)
      end

      def table
        dm.person_table
      end
    end
  end
end
