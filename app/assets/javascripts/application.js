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
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function(){
	
	$("#listacanciones tr").click(function () {
		  $("#listacanciones tr").css("background-color", "transparent");
		  $(this).css("background-color", "orange");
	});

	$("#control").on('ended', function() {
   		alert('Canción terminada!');
	});
	
	/*
	$(".play").click(function () {
		//$(".play").css("background-color", "transparent");
		//$("#listacanciones tr").css("background-color", "transparent");
		//$(this).css("background-color", "green");
		
		$("#control").remove();
		    
	});
	
	var audio = document.getElmentById('control');
	audio.addEventListener("ended", function() {
		$("#listacanciones tr").css("background-color", "green");
	    audio.src = "#{@songs.first.audio.url}";
	    audio.play();
	});
	
	*/
	
	
      
   
});