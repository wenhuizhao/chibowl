module Convert
  extend ActiveSupport::Concern

  included  do
    before_action :convert_date
  end

  protected

  def convert_date
    self.params = ActionController::Parameters.new(build_date(params.to_unsafe_h))
  end

  def build_date(params)
    return params.map{|e| build_date(e)} if  params.is_a? Array

    return params unless params.is_a? Hash

    params.reduce({}) do |hash, (key, value)|
      if result = (/(.*)\(\di\)\z/).match(key)
        params_name = result[1]
        date_params = (1..3).map do |index|
          params.delete("#{params_name}(#{index}i)").to_i
        end
        hash[params_name] =  Date.civil(*date_params)
      else
        hash[key] = build_date(value)
      end

      hash
    end
  end
end
