// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// 		.JS LLAMADOS POR RAILS
//= require jquery
//= require jquery_ujs
//= require private_pub
//
//		LIBRERIAS DE JQUERY
//= require libs/jquery-migrate-1.1.1
//= require libs/plugins
//= require libs/modernizr-2.0.6.min
//= require libs/popbox
//= require libs/gumby
//= require libs/jquery-ui
//= require libs/jquery.endless-scroll
//= require libs/jquery.color
//= require libs/jquery.Jcrop
//= require libs/jquery.mousewheel.min
//= require libs/jquery.tagsphere
//= require libs/jquery.prettyPhoto
//= require libs/jquery.address-1.5.min
//= require libs/jquery.form
//
// 		NUESTOS .JS
//= require vote
//= require users
//= require user_sessions
//= require search
//= require post
//= require comment
//= require notification
//= require charCount

function resetForm($form) {
	$form.find('input:text, input:password, input:file, select, textarea').val('');
	$form.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');
}

function esNumero(num) {
	var regExp = new RegExp('^\\d+$');
	return regExp.test(num);
}

jQuery.ajaxSetup({
	'beforeSend' : function(xhr) {
		xhr.setRequestHeader("Accept", "text/javascript")
	}
})

jQuery.fn.submitWithAjax = function() {
	this.submit(function() {
		$.post(this.action, $(this).serialize(), function() {
		}, "script");
		return false;
	})
	return this;
};

$(document).ready(function() {
	$("#delete").submitWithAjax();
	$("#new").submitWithAjax();
	$("#tumblear").button();
	
	$("#cargandoPag").dialog({
		autoOpen : false,
		minHeight : 66,
		minWidth : 66,
		maxWidth : 66,
		draggable : false,
		resizable : false,
		dialogClass : "cargandoPagPost"
	});

	$( "#ventanaEmergente" ).dialog({
    	autoOpen: false,
    	modal: true,
		resizable : false,
		height : 650,
		width : 650
    });

	$("#form-new").dialog({
		autoOpen : false,
		resizable : false,
		height : 180,
		width : 600,
		closeOnEscape : true
	});

	$.address.change(function(event) {
        // Set shortcut to URI value
        var uri = event.value;
        // Run ajax call and get JSON data
		if($("#notice").length > 0)
			$("#notice").remove();
		if($("#error").length > 0)
			$("#error").remove();
		$('html, body').animate({ scrollTop: 0 }, 0);
		$("#cargandoPag").dialog("open");
		if ($("#remote").length > 0) {
			$("#remote").val(url);
		}
		var url = $(location).attr('protocol') + "//" + $(location).attr('host') + uri;
		$.getScript(url + "?remote=true");
    });

	$("#open-publicar").click(function() {
		$("#post_content").val("");
		if ($("#destinatario").val() != "")
			$("#post_content").val($("#destinatario").val()).trigger('update');
		else
			$("#post_content").trigger('charcount');
		$("#form-new").dialog("open");
		$("#post_content").focus();
	});

	$("#tumblear").click(function() {
		if ($("#post_content").val().length == 0) {
			alert("El mensaje está vacío ¿seguro no quieres decir nada?");
			return false;
		}else{
			$("#form-new").dialog("close");
		}
	});
	
	
	function CambioTamano() {
		if ($(window).width()<=780)
		{
			$("#mainboard").css({"position":"static", "width" : "auto", "margin" : "0 auto"});
			$(".board-background").css({"margin-top": "80px", "width" : "auto !important"});			
			$("#main").css({"margin-top": "70px"});
		}
		else
		{
			$("#mainboard").css({"position":"fixed", "width" : "100%"});
			$(".board-background").css({"margin-top": "5px", "width" : "220px"});
			$("#main").css({"margin-top": "20px"});
		}
		
		if ($(window).height()<=599)
		{
			$("#marcofoto img").css({"height":"100"});
		}
		else
		{
			$("#marcofoto img").css({"height":"auto"});
		}
	}
	CambioTamano();	
    $(window).resize(function(){
		CambioTamano();	
    });
});

