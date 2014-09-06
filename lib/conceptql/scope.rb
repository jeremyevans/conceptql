module ConceptQL
  class Scope
    @@count = 0
    def initialize(scope = nil)
      @defined = {}
      @funcs = {}
      @salt = (@@count += 1)
      @parent = scope
    end

    def add_func(name, obj)
      funcs[namify(name)] = obj
    end

    def remove_func(name)
      funcs.delete(namify(name))
    end

    def functions(name)
      result = funcs[namify(name)]
      while result.nil?
        s = @parent
        raise "#{self} - Failed to find a function for #{name}" if s.nil?
        result = s.functions(name)
      end
      result
    end

    def add_definition(name, obj)
      defined[namify(name)] = obj
    end

    def remove_definition(name)
      defined.delete(namify(name))
    end

    def definitions(name)
      result = defined[namify(name)]
      while result.nil?
        s = @parent
        raise "#{self} - Failed to find a definition for #{name}" if s.nil?
        result = s.definitions(name)
      end
      result
    end

    def namify(name)
      digest = Zlib.crc32 name + salt.to_s
      ('_' + digest.to_s).to_sym
    end

    def inspect
      to_s
    end

    def to_s
      "[scope #{salt}]"
    end

    private
    attr :defined, :funcs, :salt
  end
end
