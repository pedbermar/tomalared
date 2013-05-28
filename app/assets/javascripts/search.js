$(document).ready(function() 
{
	
	// Funciones para cojer la ultima palabra
	function split( val ) {
      return val.split( / \s*/ );
    }
    function extractLast( term ) {
      return split( term ).pop();
    }
    
    //Autocomplete del buscado
	$( "#q" ).autocomplete(
	{
	    source: "/search/searched",
	    select: function(event, ui) 
	    {
			$.address.value(("/post/"+ ui.item.tipo+"/" + ui.item.name)); 
		},
	    response: function(event, ui) {
	    	var dataString  = $(this).val();        
	
	        if (!ui.content.length) 
	        {
	        	if (dataString.length > 3)
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
		return $( "<li class=\"resultSearch\"></li>" )
		.data( "item.autocomplete", item )
		.append( "<a href=\"/post/"+ item.tipo+ "/"+ item.name+ "\"><div class='a-autocomplete'><img width='30' src='"+item.img+"' onError=\"this.src='/img/default.jpg';\"> "+ item.label + "</div></a>")
		.appendTo( ul );
	};

	$(document).on("click", ".resultSearch a", function(event) {
		$.address.value($(this).attr('href'));
		return false;
	});
	
	
	
	//Autocomplete del publicar
	$( "#post_content" )
      // don't navigate away from the field on tab when selecting an item
      .bind( "keydown", function( event ) {
        if ( event.keyCode === $.ui.keyCode.TAB &&
            $( this ).data( "ui-autocomplete" ).menu.active ) {
          event.preventDefault();
        }
      })
      .autocomplete({
        source: function( request, response ) 
        {
          $.getJSON( "/search/searched", 
          {
            term: extractLast( request.term )
          }, response );
        },
        search: function() 
        {
          // custom minLength
          var term = extractLast( this.value );
          if ( term.length < 2 ) 
          {
            return false;
          }
          
          if (term.substr(0,1) != "@" && term.substr(0,1) != "#" )
          {
          	return false;
          }
        },
        autoFocus: true,
        select: function( event, ui ) 
        {
          var terms = split( this.value );
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push( ui.item.value );
          // add placeholder to get the comma-and-space at the end
          terms.push( "" );
          this.value = terms.join( " " );
          return false;
        }
      }).data("autocomplete")._renderItem = function( ul, item ) 
	{
		return $( "<li class=\"resultSearch\"></li>" )
		.data( "item.autocomplete", item )
		.append( "<a ><div class='a-autocomplete'><img width='30' src='"+item.img+"' onError=\"this.src='/img/default.jpg';\"> "+ item.label + "</div></a>")
		.appendTo( ul );
	};
});