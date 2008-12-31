module ActiveRecord #:nodoc:
  module Serialization
    def to_gviz(options = {})
      GvizSerializer.new(self, options).to_s
    end
    
    class GvizSerializer < ActiveRecord::Serialization::Serializer #:nodoc:
      def serialize
        "{c:[" + serializable_attributes.map { |a| a.value }.join(",") + "]}"
      end
      
      def serializable_attributes
        serializable_attributes = serializable_attribute_names.map { |name| Attribute.new(name, @record) }
        serializable_attributes.reject { |a| [:binary,:yaml].include?(a.type) }
      end
      
      class Attribute
        attr_reader :name, :value, :type
        
        def initialize(name, record)
          @name, @record = name, record
          
          @type = compute_type
          @value = compute_value
        end
        
        protected
          def compute_type
            type = @record.class.serialized_attributes.has_key?(name) ? :yaml : @record.class.columns_hash[name].type
            
            case type
            when :text
              :string
            when :time
              :timeofday
            when :integer
              :number
            when :float
              :number
            when :decimal
              :number
            else
              type
            end
          end
          
          def compute_value
            value = @record.send(name)
            
            return "null" if (value.nil? || value == "")
            
            case type
            when :string
              "{v:\'#{value}\'}"
            when :boolean
              "{v:\'#{value}\'}"
            when :number
              "{v:#{value}}"
            when :date
              "{v:new Date(#{value.year},#{value.month},#{value.day})}"
            when :datetime
              "{v:new Date(#{value.year},#{value.month},#{value.day},#{value.hour},#{value.min},#{value.sec})}"
            when :timestamp
              "{v:new Date(#{value.year},#{value.month},#{value.day},#{value.hour},#{value.min},#{value.sec})}"
            when :timeofday
              "{v:[#{value.hour},#{value.min},#{value.sec}]}"
            else
              "null"
            end
          end

      end
    end
  end
end
