class Instance < ActiveRecord::Base
  belongs_to :user
  scope :createdby,-> {order('created_at DESC')}
  def paypal_url(inst)
    if inst.temp_status.nil?
      if inst.duration == 1
        if inst.size == "512mb"
          price = '6'
        elsif inst.size == '1gb'
          price = '11'
        elsif inst.size == '2gb'
          price = '22'
        end
      elsif inst.duration == 3
        if inst.size == "512mb"
          if inst.user.had_instance  
            price = '15.99'
          else
            price ='12'
          end
        elsif inst.size == '1gb'
          price = '28.99'
        elsif inst.size == '2gb'
          price = '57.99'
        end
      elsif inst.duration == 6
        if inst.size == "512mb"
          if inst.user.had_instance  
            price = '31.99'
          else
            price = '30'
          end
        elsif inst.size == '1gb'
          price = '59.99'
        elsif inst.size == '2gb'
          price = '121.99'
        end
      end
    elsif inst.temp_status == "Renewing" || inst.temp_status == "Resizing"
      if inst.size == "512mb"
        price = 6 * duration
      elsif inst.size == '1gb'
        price = 11 * duration
      else
        price = 22 * duration
      end
    end
    if inst.duration == 1
      month = "Month"
    else
      month = "Months"
    end
    inst.update_attributes(price: price)
    values = {
        business: "soporte@iftech.cl",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}/instances/",
        invoice: "#{inst.name.upcase}#{inst.id}LIDEPLOY#{Time.now}",
        custom: inst.size,
        amount: price,
        item_name: "#{inst.size.upcase} Server for #{inst.duration} #{month} on iftech.cl",
        item_number: inst.id,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/hooks"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end
