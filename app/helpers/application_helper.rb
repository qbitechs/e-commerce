module ApplicationHelper
  include Pagy::Frontend

  def nav_link_classes(path)
    if current_page?(path)
      "text-indigo-600 font-medium flex items-center py-1 border-b-2 border-indigo-500"
    else
      "text-gray-600 hover:text-indigo-600 transition-colors font-medium flex items-center py-1 border-b-2 border-transparent hover:border-indigo-300"
    end
  end
end
