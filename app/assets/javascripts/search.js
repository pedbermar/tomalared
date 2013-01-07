$(document).ready(function() {
			$( "#q" ).autocomplete({
			    source: "/search/searched",
		        select: function(event, ui) 
		        {
	    	      window.location = ("/post/user/" + item.name)
    	  		},
		        response: function(event, ui) {
		            if (!ui.content.length) {
		                $("#resultado-busqueda").text("No results found");
	                } else {
		                $("#resultado-busqueda").empty();
		            }	            
		        },
		      	minLength: 1,
		      	autoFocus: false      	
    		})
    		.data("autocomplete")._renderItem = function( ul, item ) 
    		{
    			return $( "<li></li>" )
        		.data( "item.autocomplete", item )
        		.append( "<a href='/post/"+ item.tipo+ "/"+ item.name+ "'><div class='a-autocomplete'><img width='30' src='"+item.img+"' onError=\"this.src='/img/default.jpg';\"> "+ item.label + "</div></a>")
        		.appendTo( ul );
    		};
	
    });