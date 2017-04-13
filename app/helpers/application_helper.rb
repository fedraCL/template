module ApplicationHelper
  
  # genera un select con los datos del mantenedor
    def manten(f, campo, datos, prompt = nil, opciones = {})
      if prompt
        f.collection_select campo, datos, :valor, :valor, {:prompt => prompt}, opciones
      else
       f.collection_select campo, datos, :valor, :valor, {}, opciones
      end
    end
  
	def flash_class(type)
		case type
		when :alert
			"alert-danger"
		when :notice
			"alert-success"
		else
			""
		end
	end
end
