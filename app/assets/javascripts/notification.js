function llegadaNotificacion(notif, html) {
	var elemento = "#notif" + notif.note_type;
	var i = 0;
	if (notif.unread == 1){
		i = 1;
		$.getScript("/notif/list?remote=true&id=" + notif.resource_id + "&type=" + notif.note_type);
	} else {
		i = -1;
		$("#notifications_" + notif._id).remove();
	}
	var contador = $(elemento).find("span.numNotif").html();
	if(contador == ""){
		contador = i;
	}else{
		contador = contador + i;
	}
	$(elemento).find("span.numNotif").html(contador);
}
