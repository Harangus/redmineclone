module ApplicationHelper

    def dark_container(&block)
        content_tag :div, class: "container-fluid bg-darker text-white mt-2 p-4 rounded shadow-lg", &block
    end

end
