require 'active_support/inflector'
module ConceptQL
  class Nodifier
    def create(type, values)
      require_relative "nodes/#{type}"
      node = "conceptQL/nodes/#{type}".camelize.constantize.new(values)
      node
    end
  end
end
