require 'fastlane/action'
require_relative '../helper/cspgyer_helper'

module Fastlane
  module Actions
    class CspgyerAction < Action
      def self.run(params)
        UI.message("The cspgyer plugin is working!")
        api_host = "http://qiniu-storage.pgyer.com/apiv1/app/upload"
        api_key = params[:api_key]
        user_key = params[:user_key]

        build_file = [
          params[:ipa]
        ].detect { |e| !e.to_s.empty? }

        if build_file.nil?
          UI.user_error!("You have to provide a build file")
        end

        UI.message "build_file: #{build_file}"

        password = params[:password]
        if password.nil?
          password = ""
        end

        update_description = params[:update_description]
        if update_description.nil?
          update_description = ""
        end

        install_type = params[:install_type]
        if install_type.nil?
          install_type = "1"
        end

        # start upload
        conn_options = {
          request: {
            timeout:       1000,
            open_timeout:  300
          }
        }

        pgyer_client = Faraday.new(nil, conn_options) do |c|
          c.request :multipart
          c.request :url_encoded
          c.response :json, content_type: /\bjson$/
          c.adapter :net_http
        end

        params = {
            '_api_key' => api_key,
            'uKey' => user_key,
            'password' => password,
            'updateDescription' => update_description,
            'installType' => install_type,
            'file' => Faraday::UploadIO.new(build_file, 'application/octet-stream')
        }

        UI.message "Start upload #{build_file} to pgyer..."

        response = pgyer_client.post api_host, params
        info = response.body

        if info['code'] != 0
          UI.user_error!("PGYER Plugin Error: #{info['message']}")
        end

        UI.success "Upload success. Visit this URL to see: https://www.pgyer.com/#{info['data']['appShortcutUrl']}"
        UI.success "Upload success. Visit this qrcode URL to see: #{info['data']['appQRCodeURL']}"
      end

      def self.description
        "蒲公英上传插件"
      end

      def self.authors
        ["李忠"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "蒲公英上传插件，可以在日志中打印qrcode地址"
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :api_key,
              env_name: "CSPGYER_API_KEY",
              description: "api_key in your pgyer account",
              optional: false,
                  type: String),
          FastlaneCore::ConfigItem.new(key: :user_key,
            env_name: "CSPGYER_USER_KEY",
            description: "user_key in your pgyer account",
            optional: false,
                type: String),
          FastlaneCore::ConfigItem.new(key: :ipa,
            env_name: "CSPGYER_IPA",
            description: "Path to your IPA file. Optional if you use the _gym_ or _xcodebuild_ action. For Mac zip the .app. For Android provide path to .apk file",
            default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH],
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Couldn't find ipa file at path '#{value}'") unless File.exist?(value)
            end,
            conflicting_options: [:apk],
            conflict_block: proc do |value|
              UI.user_error!("You can't use 'ipa' and '#{value.key}' options in one run")
            end),  
            FastlaneCore::ConfigItem.new(key: :password,
              env_name: "CSPGYER_PASSWORD",
           description: "set password to protect app",
              optional: true,
                  type: String),
          FastlaneCore::ConfigItem.new(key: :update_description,
              env_name: "CSPGYER_UPDATE_DESCRIPTION",
              description: "set update description for app",
              optional: true,
                  type: String),
          FastlaneCore::ConfigItem.new(key: :install_type,
              env_name: "CSPGYER_INSTALL_TYPE",
              description: "set install type for app (1=public, 2=password, 3=invite). Please set as a string",
              optional: true,
                  type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios].include?(platform)
        true
      end
    end
  end
end
