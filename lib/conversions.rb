module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Array #:nodoc:
      module Conversions
        def to_gviz(options = {})
          raise "Not all elements respond to to_gviz" unless all?{|e| e.respond_to? :to_gviz }
          
          response = ["version:'0.5'"]
          
          if req_id = options.delete(:req_id)
            response << "reqId:'#{req_id}'"
          end
          
          if empty?
            response << "status:'error',errors:[{reason:'other',message:'No results'}]"
          else
            response << table(options)
          end

          wrap_response(response.join(","))
        end
        
        protected
          def wrap_response(gviz)
            "google.visualization.Query.setResponse({#{gviz}});"
          end
        
          def table(options)
            "table:{#{gviz_columns(options)},#{gviz_rows(options)}}"
          end
        
          def columns(options)
            ActiveRecord::Serialization::GvizSerializer.new(first, options).serializable_attributes
          end
        
          def gviz_rows(options)
            "rows:[" + map{ |row| row.to_gviz(options) }.join(",") + "]"
          end
          
          def gviz_columns(options)
            "cols:[" + columns(options).compact.map{ |a| gviz_column(a) }.join(",") + "]"
          end
          
          def gviz_column(col)
            "{id:\'#{col.name}\',label:\'#{col.name.humanize}\',type:\'#{col.type}\'}"
          end
      end
    end
  end
end