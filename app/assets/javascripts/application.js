//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

// js routes wrapper initialization
var _routes = {};

$(document).ready(function(){

	$("#song_list tr:not(:first)").dblclick(function () {
    play($(this));
	});

  $(document).on('click', '#next_song', function() {
    next_row_song = row_next_to(playing_song_row());
    play(next_row_song);
  });
});

function play(song_row) {
  id = song_row.data('song-id');

  $.get(_routes['playSongsPathJS'], { id: id })
    .done(function() {
      $(".info").removeClass("info")
      song_row.addClass("info");

      playNextAtTheEnd(song_row);
    });
}

function playNextAtTheEnd(song_row) {
  var audio = document.getElementById('audio');
  audio.addEventListener('ended',function() {
    next_row_song = row_next_to(song_row);
    play(next_row_song);
  });
}

function row_next_to(song_row) {
  return song_row.next();
}

function playing_song_id() {
  return $('#audio').data('song-id');
}

function playing_song_row() {
  return $('#song_' + playing_song_id());
}

function first_song_row() {
  return $("#song_list tr:not(:first):first");
}
