require_relative '../helper'

describe ConceptQL::Operators::ConditionType do
  it "should produce correct results" do
    criteria_counts(
      [:condition_type, 'inpatient']
    ).must_equal("condition_occurrence"=>1372)

    criteria_counts(
      [:condition_type, 'outpatient']
    ).must_equal("condition_occurrence"=>32672)

    criteria_counts(
      [:condition_type, 'inpatient_primary']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'outpatient_primary']
    ).must_equal("condition_occurrence"=>14762)

    criteria_counts(
      [:condition_type, 'ehr_problem_list']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'condition_era']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'condition_era_0_day_window']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'condition_era_30_day_window']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'primary']
    ).must_equal("condition_occurrence"=>14762)

    criteria_counts(
      [:condition_type, 'outpatient_detail']
    ).must_equal("condition_occurrence"=>32672)

    criteria_counts(
      [:condition_type, 'outpatient_header']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'inpatient_detail']
    ).must_equal({})

    criteria_counts(
      [:condition_type, 'inpatient_header']
    ).must_equal("condition_occurrence"=>1372)

    criteria_counts(
      [:condition_type, 'inpatient_header_2']
    ).must_equal("condition_occurrence"=>170)

    criteria_counts(
      [:condition_type, 'inpatient_header_3']
    ).must_equal("condition_occurrence"=>168)

    criteria_counts(
      [:condition_type, 'inpatient_header_4']
    ).must_equal("condition_occurrence"=>164)

    criteria_counts(
      [:condition_type, 'inpatient_header_5']
    ).must_equal("condition_occurrence"=>158)

  end
end