function actNotif() {
	$.getScript($(location).attr('origin') + "/notif/list?remote=true");
	setTimeout(actNotif, 5000);
}
$(document).ready(function() {
	actNotif();
});