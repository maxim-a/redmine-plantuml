class PlantumlController < ApplicationController
  if Redmine::VERSION::MAJOR < 4 || (Redmine::VERSION::MAJOR == 4 && Redmine::VERSION::MINOR < 1)
    unloadable
  end

  def convert
    frmt = PlantumlHelper.check_format(params[:content_type])
    filename = params[:filename]
    send_file(PlantumlHelper.plantuml_file(filename, frmt[:ext]), type: frmt[:content_type], disposition: frmt[:inline])
  end
end
