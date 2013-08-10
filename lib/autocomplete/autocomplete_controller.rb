
class AutocompleteController < ActionController::Base
  include Autocomplete::ViewHelpers
  # Here we are getting the hash name and finding the Hash
  # Again we are parse the hash and pass the options into auto_completion_json helper.
  # It will return result
  def autocomplete
    class_name=AUTO_COMPLETION_MAPPING[params[:hash].to_sym][:class_name]
    query =AUTO_COMPLETION_MAPPING[params[:hash].to_sym][:search_query]
    search_field=AUTO_COMPLETION_MAPPING[params[:hash].to_sym][:search_field]
    model_name = class_name.class.to_s == "String" ? class_name.constantize : class_name
    result=auto_completion_json(params[:q],query,search_field,model_name,params[:hash])
    render :text => result
  end
end