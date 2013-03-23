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

	def muestraNotificaciones(notifs, type, unread)
		@notifications = Array.new
		notifs.each do |n|
			if n.note_type == type and n.unread == unread
				@notifications << n
			end
		end
		@notifications.sort_by {|n| n.id}
		@notifications.reverse
		"#{render :partial => "notification/list"}"
	end
end
