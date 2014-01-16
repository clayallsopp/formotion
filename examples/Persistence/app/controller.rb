class AccountSettingsController < Formotion::FormController
  PERSIST_AS = :account_settings

  API_SERVER = "hello_world"
  API_KEY = "123123secret"

  SPECIAL_OPTIONS_HASH = {
    title: "Special options",
    sections: [{
      rows: [{
        title: "Phone Number",
        value: "555-555-5555",
        type: "phone",
        key: "phone"
      }, {
        title: "Address",
        value: "90210",
        type: "string",
        key: "address"
      }]
    }]
  }

  DISPLAY_KEY_HASH = {
    title: "Alert Sounds",
    sections: [{
      key: :sound,
      select_one: true,
      rows: [{
        title: "Beeps",
        key: :Beeps,
        value: true,
        type: :check
      },{
        title: "Boops",
        key: :Boops,
        type: :check
      }]
    }]
  }

  SETTINGS_HASH = {
      title: "Application",
      persist_as: PERSIST_AS,
      sections: [{
        rows: [{
          title: "Server",
          type: :string,
          key: :server,
          value: API_SERVER,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "API Key",
          value: API_KEY,
          type: :string,
          key: :api_key,
          secure: false,
          auto_correction: :no,
          auto_capitalization: :none
        }]
      }, {
        rows: [{
          title: "Name",
          type: :string,
          key: :name,
          value: "Clay",
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          value: "Secret",
          type: :string,
          key: :password,
          secure: false,
          auto_correction: :no,
          auto_capitalization: :none
        }]
      }, {
        title: "w/ Subforms",
        rows: [{
          title: "Special Options",
          type: :subform,
          key: :special_options,
          subform: SPECIAL_OPTIONS_HASH
        }, {
          title: "w/ Display Key",
          type: :subform,
          key: :alert_sound,
          display_key: :sound,
          subform: DISPLAY_KEY_HASH
        }]
      }]
    }

  def self.set_api_url_and_key_from_saved_settings
    form = Formotion::Form.new(SETTINGS_HASH)
    form.open
    server_url_str = form.render[:server]
    server_api_key = form.render[:api_key]
    p "server_url_str #{server_url_str}"
    p "server_api_key #{server_api_key}"
    if server_url_str && server_api_key
      if NSURLConnection.canHandleRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(server_url_str)))
        #Tillless::ApiHelper.set_api_url(server_url_str)
        #Tillless::ApiHelper.set_api_key(server_api_key)
      else
        NSLog "Unable to set url from saved config in app_delegate: #{server_url_str}"
      end
    else
      NSLog "No configuration found"
    end
  end

  def initController
    f = Formotion::Form.new(SETTINGS_HASH)
    initWithForm(f)
  end
end