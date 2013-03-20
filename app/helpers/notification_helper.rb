module NotificationHelper
	def cuentaNotificaciones(notifications, type, unread)
		num = 0
		style = ""
		notifications.each do |n|
			if n.note_type == type and n.unread == unread
				num = num + 1
			end
		end
		if num == 0
			style = "style=\"display:none\""
		end
		"<span class=\"numNotif\" #{style}>#{num}</span>"
	end

	def muestraNotificaciones(notifications, type, unread)
		@notifications = Array.new
		notifications.each do |n|
			if n.note_type == type and n.unread == unread
				@notifications << n
			end
		end
		render :partial => "notification/list", :collection => @notifications
	end
end
