# frozen_string_literal: true

module PlantumlPdfPatch
  require_dependency 'redmine/export/pdf'

  def self.included(base) # :nodoc:
    base.send(:prepend, InstanceMethod)

    if Redmine::VERSION::MAJOR < 4 || (Redmine::VERSION::MAJOR == 4 && Redmine::VERSION::MINOR < 1)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
      end
    end
  end

  module InstanceMethod
    def get_image_filename(attrname)
      if attrname =~ %r{^/plantuml/png/(\w+)\.png$}i
        PlantumlHelper.plantuml_file(Regexp.last_match[1], '.png')
      else
        super(attrname)
      end
    end
  end
end
