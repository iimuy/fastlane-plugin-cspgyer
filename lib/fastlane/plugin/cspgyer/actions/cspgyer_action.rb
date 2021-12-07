require 'fastlane/action'
require_relative '../helper/cspgyer_helper'

module Fastlane
  module Actions
    class CspgyerAction < Action
      def self.run(params)
        UI.message("The cspgyer plugin is working!")
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
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "CSPGYER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
