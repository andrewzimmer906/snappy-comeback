/*# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#jQuery -> $('#gif_tag_names').autocomplete
#	source: $('#gif_tag_names').data('autocomplete-source')
*/	


    
$(function() {
		function split( val ) {
			return val.split( /,\s*/ );
		}
		function extractLast( term ) {
			return split( term ).pop();
		}

		$( "#gif_tag_names" )
			// don't navigate away from the field on tab when selecting an item
			.bind( "keydown", function( event ) {
				if ( event.keyCode === $.ui.keyCode.TAB &&
						$( this ).data( "autocomplete" ).menu.active ) {
					event.preventDefault();
				}
			})
			.autocomplete({
				minLength: 0,
				source: function( request, response ) {
					// delegate back to autocomplete, but extract the last term
					response( $.ui.autocomplete.filter(
						$( "#gif_tag_names" ).data('autocomplete-source'), extractLast( request.term ) ) );
				},
				focus: function() {
					// prevent value inserted on focus
					return false;
				},
				select: function( event, ui ) {
					var terms = split( this.value );
					// remove the current input
					terms.pop();
					// add the selected item
					terms.push( ui.item.value );
					// add placeholder to get the comma-and-space at the end
					terms.push( "" );
					this.value = terms.join( ", " );
					return false;
				}
			});
	});
	
$(document).ready(function(){
	$('a.copy_url').zclip({
		path:'ZeroClipboard.swf',
		copy:function(){
		    return $(this).attr('data-url');
		},
		afterCopy:function(){
		   console.log("copied");
		}
		
	});
	
	$('a.copy_url').fadeTo(0,0);
	
	$(".gif-image-bg").hover(
		function() {
			console.log('hover on');
			$(this).find('a').animate({ opacity:1.0}, 250);
		},
		function() {
			console.log('hover off');
			$(this).find('a').animate({ opacity:0.0}, 250);
		}
	);
});

