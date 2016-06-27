#!/usr/bin/env ruby

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

require 'xcodeproj'

xcproj = Xcodeproj::Project.open("pinduoduo.xcodeproj")
xcproj.recreate_user_schemes
xcproj.save

test_target = xcproj.targets[1]

scheme = Scheme.find_scheme("pinduoduo", "pinduoduo")
test_action = scheme.test_action
test_action.code_coverage_enabled = true

test_reference = Xcodeproj::XCScheme::TestAction::TestableReference.new(test_target)
test_action.add_testable(test_reference)
scheme.save!
