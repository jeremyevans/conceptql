require_relative 'standard_vocabulary_operator'

module ConceptQL
  module Operators
    class CptOrHcpcs < StandardVocabularyOperator
      register __FILE__, :omopv4

      preferred_name 'CPT/HCPCS'
      desc 'Searches the procedure_occurrence table for all procedures with matching CPT/HCPCS codes'
      argument :codes, type: :codelist, vocab: ['CPT', 'HCPCS']
      predominant_types :procedure_occurrence

      def table
        :procedure_occurrence
      end

      def vocabulary_id
        [4, 5]
      end

      def concept_column
        :procedure_concept_id
      end
    end
  end
end