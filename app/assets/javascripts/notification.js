function llegadaNotificacion(notif) {
	var elemento = "#notif" + notif.note_type;
	var i = 0;
	if (notif.unread == 1){
		i = 1;
		$.getScript("/notif/list?remote=true&id=" + notif.post_id + "&type=" + notif.note_type);
	} else {
		i = -1;
		$("#notifications_" + notif._id).remove();
	}
	var contador = $(elemento + " span.numNotif").html();
	if(contador == ""){
		contador = i;
	}else{
		contador = parseInt(contador) + parseInt(i);
	}
	$(elemento + " span.numNotif").html(contador);
	if(parseInt(contador) > 0)
		$("#notif<%=params[:note_type]%> span.numNotif").show();
	else
		$("#notif<%=params[:note_type]%> span.numNotif").hide();
}
