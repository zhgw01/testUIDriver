#!/usr/bin/env ruby

require 'xcodeproj'

module Scheme
  def self.find_scheme(project_name, scheme_name)
    source_path = "./" + project_name + ".xcodeproj/" + "xcuserdata"
    pattern_path = File.join source_path, '*.{xcuserdatad}'
    xcscheme_paths = Dir.glob(pattern_path).map { |container_path|
      File.join container_path,  'xcschemes', "#{scheme_name}.xcscheme"
    }.keep_if { |xcscheme_path|

      File.exists? xcscheme_path
    }
    if xcscheme_paths.count > 1
      puts "Fatal Error: Find multiple schemes named '#{scheme_name}'"
      exit 1
    elsif xcscheme_paths.count == 0
      puts "Fatal Error: Cannot find scheme named '#{scheme_name}'"
      exit 1
    else
      return Xcodeproj::XCScheme.new(xcscheme_paths[0])
    end
  end
end

class Helper
	def initialize(xcproj)
		@xcodeproj =xcproj
	end 

	def development_team=(value)
          attributes = @xcodeproj.root_object.attributes
          attributes["TargetAttributes"] ||= {}
          @xcodeproj.targets.each do |target|
            attributes["TargetAttributes"][target.uuid] ||= {}
            attributes["TargetAttributes"][target.uuid]["DevelopmentTeam"] = value
          end
          @xcodeproj.save
        end

	def code_signing_identity=(value)
          each_build_settings do |build_settings|
            build_settings.keys.each do |setting_name|
              build_settings.delete(setting_name) if setting_name.start_with?("CODE_SIGN_IDENTITY[sdk=")
            end
            build_settings["CODE_SIGN_IDENTITY"] = value
          end
          @xcodeproj.save
        end

	def disable_entitlement()
          each_build_settings do |build_settings|
            build_settings.keys.each do |setting_name|
              build_settings.delete(setting_name) if setting_name.start_with?("CODE_SIGN_ENTITLEMENTS")
            end
          end
          @xcodeproj.save
        end
	
        
        def each_build_settings
          @xcodeproj.build_configurations.each do |build_configuration|
            yield build_configuration.build_settings
          end
          @xcodeproj.targets.each do |target|
            target.build_configurations.each do |build_configuration|
              yield build_configuration.build_settings
            end
          end
        end	

end

def change_team(xcproj)
	pbxproject = xcproj.objects_by_uuid["4903B4471C5A16460050AF35"]
	target_attribute = pbxproject.attributes["TargetAttributes"]["4903B44E1C5A16460050AF35"]
	target_attribute["DevelopmentTeam"] = "TPATRJ5VJF"

	system_capacity = target_attribute["SystemCapabilities"]
	system_capacity["com.apple.Push"]["enabled"] = "0"
	system_capacity["com.apple.SafariKeychain"]["enabled"] = "0"
end

xcproj = Xcodeproj::Project.open("pinduoduo.xcodeproj")
xcproj.recreate_user_schemes
change_team(xcproj)
helper = Helper.new(xcproj)
helper.code_signing_identity = "iPhone Distribution: Dongguan Leqee Network Technology Company Limited"
helper.disable_entitlement

xcproj.save

test_target = xcproj.targets[1]

scheme = Scheme.find_scheme("pinduoduo", "pinduoduo")
test_action = scheme.test_action
test_action.code_coverage_enabled = true

test_reference = Xcodeproj::XCScheme::TestAction::TestableReference.new(test_target)
test_action.add_testable(test_reference)
scheme.save!

