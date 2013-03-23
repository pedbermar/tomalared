$(document).ready(function() 
{
	$( "#q" ).autocomplete({
	    source: "/search/searched",
	    select: function(event, ui) 
	    {
	      var url = $(location).attr('protocol')
			+ "//" + $(location).attr('host')
			+ "/post/"+ ui.item.tipo+"/" + ui.item.name;
			$("#remote").val(url);
			$.getScript(url + "?remote=true&soloposts=true");
		},
	    response: function(event, ui) 
	    {
	    	var dataString  = $(this).val();        
	
	        if (!ui.content.length) 
	        {
	        	if (dataString.length < 3)
	        		{
	            		$("#resultado-busqueda").empty();
	            	}
	            	else
	            	{
	            		$("#resultado-busqueda").text("No result");
	            	} 
	        } 
	        else 
	        {
	            $("#resultado-busqueda").empty();
	        }	            
	    },
	  	minLength: 2,
	  	autoFocus: true	
	})
	.data("autocomplete")._renderItem = function( ul, item ) 
	{
		return $( "<li></li>" )
		.data( "item.autocomplete", item )
		.append( "<a href='/post/"+ item.tipo+ "/"+ item.name+ "'><div class='a-autocomplete'><img width='30' src='"+item.img+"' onError=\"this.src='/img/default.jpg';\"> "+ item.label + "</div></a>")
		.appendTo( ul );
	};
});
