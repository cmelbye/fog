module Fog
  class Model

    def self._load(marshalled)
      new(Marshal.load(marshalled))
    end

    def self.aliases
      @aliases ||= {}
    end

    def self.attributes
      @attributes ||= []
    end

    def self.attribute(name, other_names = [])
      class_eval <<-EOS, __FILE__, __LINE__
        attr_accessor :#{name}
      EOS
      @attributes ||= []
      @attributes |= [name]
      for other_name in [*other_names]
        aliases[other_name] = name
      end
    end

    def self.identity(name, other_names = [])
      @identity = name
      self.attribute(name, other_names)
    end

    def _dump
      Marshal.dump(attributes)
    end

    attr_accessor :connection

    def attributes
      attributes = {}
      for attribute in self.class.attributes
        attributes[attribute] = send("#{attribute}")
      end
      attributes
    end

    def collection
      @collection
    end

    def identity
      send(self.class.instance_variable_get('@identity'))
    end

    def initialize(new_attributes = {})
      merge_attributes(new_attributes)
    end

    def inspect
      data = "#<#{self.class.name}"
      for attribute in self.class.attributes
        data << " #{attribute}=#{send(attribute).inspect}"
      end
      data << ">"
    end

    def merge_attributes(new_attributes = {})
      for key, value in new_attributes
        if aliased_key = self.class.aliases[key]
          send("#{aliased_key}=", value)
        else
          send("#{key}=", value)
        end
      end
      self
    end

    def new_record?
      !identity
    end

    def reload
      new_attributes = collection.get(identity).attributes
      merge_attributes(new_attributes)
    end

    def requires(*args)
      missing = []
      for arg in [:connection] | args
        missing << arg unless send("#{arg}")
      end
      unless missing.empty?
        if missing.length == 1
          raise(ArgumentError, "#{missing.first} is required for this operation")
        else
          raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
        end
      end
    end

    def wait_for(timeout = 600, &block)
      start = Time.now
      until instance_eval(&block)
        if Time.now - start > timeout
          break
        end
        reload
        sleep(1)
      end
    end

    private

    def collection=(new_collection)
      @collection = new_collection
    end

    def remap_attributes(attributes, mapping)
      for key, value in mapping
        if attributes.key?(key)
          attributes[value] = attributes.delete(key)
        end
      end
    end

  end
end
