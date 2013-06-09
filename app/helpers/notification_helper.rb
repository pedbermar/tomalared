module NotificationHelper
	def cuentaNotificaciones(notifications, type, unread)
		num = 0
		style = ""
		num = notifications.where(:note_type => type, :unread => unread).count
		if num <= 0
			style = "style=\"display:none\""
		end
		"<span class=\"numNotif\" #{style}>#{num}</span>"
	end

	def muestraNotificaciones(notifs, type, unread)
		@notifications = notifs.where(:note_type => type, :unread => unread).sort_by {|n| n.id}.reverse
		"#{render :partial => "notification/list"}"
	end
end
