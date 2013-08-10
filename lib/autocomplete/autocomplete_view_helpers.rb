module Autocomplete #:nodoc
  module ViewHelpers #:nodoc
    
#In this method we are getting the hast name and finding the hash value and split all the values in seperate seperate variable and send through the url
#This url will send the request to autocomplete/autocomplete_controller autocomplete method.    
    def autocompletion_field(hash,options={})
      get_hash =AUTO_COMPLETION_MAPPING[hash.to_sym]
      if get_hash
        name = get_hash[:name]
        id   = get_hash[:name].gsub('[','_').chop
        display_name =get_hash[:display_name]
        value=get_hash[:value]
      else
        raise "Hash is not defined ======= Please configure the hash => #{hash} in config/initializers/auto_completion.rb"
      end
      new_name = get_hash[:new_name]
      column_name = get_hash[:column_name] || get_hash[:name].split("[").last.split("_").first
      model_name=  get_hash[:model_name] || get_hash[:name].split("[").first
      maximum_allowed= options[:maximum_allowed] || 45
      allow_new=options[:allow_new] || false
      tool_tip = options[:tooltip] || false
      complete_text = options[:default_selection] || 'Please enter value'
      null_message = options[:null_message] || 'No results'
      sort_class=options[:sort] || false

      "<input type='text' id='#{id}'/>
        <script type='text/javascript'>
        $(document).ready(function() {
             $('##{id}').tokenInput(#{search_data(hash)},
                {
                preventDuplicates: true,
                theme: 'facebook',
                minChars: 1,
                hintText: '#{complete_text}',
                #{get_selected_data(options[:selected],display_name)}
                noResultsText: '#{null_message}',
                tokenLimit:#{maximum_allowed},
                tokenValue: 'kingston'
               #{get_element_name(allow_new,name,new_name)}
            });
        });
        </script>"
    end

# Here parse the json we need two methods def id ,def name,so,we are dynamically add the methods.
    def auto_completion_json(keyword,query,search_field,model_name,hash)
      #@site=Ambient.current_site
      #@classified=Classified.find(session[:classified_id]) if session[:classified_id]
      instance_variables_to_set_and_quey = AUTO_COMPLETION_MAPPING[hash.to_sym][:instance_variables_to_set_and_quey] || [] << ["@site","Site.find(session[:site_id])"]
      instance_variables_to_set_and_quey.each do |array|
        instance_variable_set(array[0],eval(array[1]))
      end
      @@hash =hash
      model_name.class_eval {
        def id
          self[AUTO_COMPLETION_MAPPING[@@hash.to_sym][:value].to_sym].to_s
        end

        def name
          @@hash.inspect
          self[AUTO_COMPLETION_MAPPING[@@hash.to_sym][:search_field].to_sym]
        end
      }
      sql="#{query}.where(['UPPER(#{search_field}) like ?','%' + '#{keyword.upcase}' + '%'])"
      #eval(query).where(["#{search_field} like ?", '%' + keyword + '%']).to_json(:only=>[:key,:value],:methods=>[:key,:value])
      eval(sql).to_json(:only=>[:name,:id],:methods=>[:name,:id])
    end
    
private

    def get_element_name(allow_new,name,new_name='Please give new_name in Hash')
      if allow_new
        ",tokenName:'#{name}[]',allowCreation:true,tokenNameNew:'#{new_name}[]'"
      else
        ",tokenName:'#{name}[]'"
      end
    end

    def get_selected_data(selected_data,display_name)
      unless selected_data.blank?
        "prePopulate:#{selected_data.collect{|k| {'id'=>k.id,'name'=>k.send(display_name)}}.to_json},"
      end
    end

    def search_data(hash)
      if AUTO_COMPLETION_MAPPING[hash.to_sym][:all_data]
      data = Util.strip_html_tags(AUTO_COMPLETION_MAPPING[hash.to_sym][:all_data].to_json)
      else
        data = "'/autocomplete?hash='+'#{hash}'"
      end
      data
    end
  end

end

ActionView::Base.module_eval do
  include Autocomplete::ViewHelpers
end