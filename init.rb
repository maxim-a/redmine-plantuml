Redmine::Plugin.register :plantuml do
  name 'PlantUML plugin for Redmine'
  description 'This is a plugin for Redmine which renders PlantUML diagrams.'
  version '0.5.5'
  url 'https://github.com/javister/plantuml'

  requires_redmine :version_or_higher => '2.6.0'

  settings(partial: 'settings/plantuml',
           default: { 'plantuml_binary' => {}, 'cache_seconds' => '0', 'allow_includes' => false })

  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render PlantUML image.
      <pre>
      {{plantuml(png)
      (Bob -> Alice : hello)
      }}
      </pre>

      Available options are:
      ** (png|svg)
EOF
    macro :plantuml do |obj, args, text|
      raise 'No PlantUML binary set.' if Setting.plugin_plantuml['plantuml_binary_default'].blank?
      raise 'No or bad arguments.' if args.size != 1
      frmt = PlantumlHelper.check_format(args.first)
      image = PlantumlHelper.plantuml(text, args.first)
      image_tag "/plantuml/#{frmt[:type]}/#{image}#{frmt[:ext]}"
    end
  end
end

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks

  unless Redmine::WikiFormatting::Textile::Helper.included_modules.include? PlantumlHelperPatch
    Redmine::WikiFormatting::Textile::Helper.send(:include, PlantumlHelperPatch)
  end
  unless Redmine::Export::PDF::ITCPDF.included_modules.include? PlantumlPdfPatch
    Redmine::Export::PDF::ITCPDF.send(:include, PlantumlPdfPatch)
  end
end
