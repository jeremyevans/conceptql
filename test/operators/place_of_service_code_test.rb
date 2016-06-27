require_relative '../helper'

describe ConceptQL::Operators::PlaceOfServiceCode do
  it "should produce correct results" do
    criteria_ids(
      [:place_of_service_code, 21]
    ).must_equal("visit_occurrence"=>[51286, 51287, 51288, 51289, 51290, 51291, 51292, 51293, 51294, 51295, 51296, 51297, 51298, 51299, 51300, 51301, 51302, 51303, 51304, 51305, 51306, 51307, 51308, 51309, 51310, 51311, 51312, 51313, 51314, 51315, 51316, 51317, 51318, 51319, 51320, 51321, 51322, 51323, 51324, 51325, 51326, 51327, 51328, 51329, 51330, 51331, 51332, 51333, 51334, 51335, 51336, 51337, 51338, 51339, 51340, 51341, 51342, 51343, 51344, 51345, 51346, 51347, 51348, 51349, 51350, 51351, 51352, 51353, 51354, 51355, 51356, 51357, 51358, 51359, 51360, 51361, 51362, 51363, 51364, 51365, 51366, 51367, 51368, 51369, 51370, 51371, 51372, 51373, 51374, 51375, 51376, 51377, 51378, 51379, 51380, 51381, 51382, 51383, 51384, 51385, 51386, 51387, 51388, 51389, 51390, 51391, 51392, 51393, 51394, 51395, 51396, 51397, 51398, 51399, 51400, 51401, 51402, 51403, 51404, 51405, 51406, 51407, 51408, 51409, 51410, 51411, 51412, 51413, 51414, 51415, 51416, 51417, 51418, 51419, 51420, 51421, 51422, 51423, 51424, 51425, 51426, 51427, 51428, 51429, 51430, 51431, 51432, 51433, 51434, 51435, 51436, 51437, 51438, 51439, 51440, 51441, 51442, 51443, 51444, 51445, 51446, 51447, 51448, 51449, 51450, 51451, 51452, 51453, 51454, 51455])
  end

  it "should handle errors when annotating" do
    query(
      [:place_of_service_code, 21, [:icd9, "412"]]
    ).annotate.must_equal(
      ["place_of_service_code",
       ["icd9", "412", {:annotation=>{:counts=>{:condition_occurrence=>{:rows=>55, :n=>42}}}, :name=>"ICD-9 CM"}],
       21,
       {:annotation=>{:counts=>{:visit_occurrence=>{:n=>0, :rows=>0}}, :errors=>[["has upstreams", ["icd9"]]]}}]
    )

    query(
      [:place_of_service_code]
    ).annotate.must_equal(
      ["place_of_service_code",
       {:annotation=>{:counts=>{:visit_occurrence=>{:n=>0, :rows=>0}}, :errors=>[["has no arguments"]]}}]
    )
  end
end
