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

  $('#next_song-js').click(function() {
    next_row_song = nextSongRow(playing_song_row());
    play(next_row_song);
  });

  $('#random-js').click(function() {
    if (isRandomSelected()) {
      $(this).removeClass("btn-info");
      $(this).addClass("btn-default");
    } else {
      $(this).removeClass("btn-default");
      $(this).addClass("btn-info");
    }
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
    next_row_song = nextSongRow(song_row);
    play(next_row_song);
  });
}

function nextSongRow(song_row) {
  if (isRandomSelected()) {
    return randomRow();
  } else {
    return song_row.next();
  }
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

function find_song_row_by_id(id) {
  return $('#song_' + id);
}

function isRandomSelected() {
  return $('#random-js').hasClass("btn-info");
}

function randomRow() {
  rows = notPlayingRows();
  random = getRandomInt(0, rows.size() - 1);
  return $(rows[random]);
}

function notPlayingRows() {
  return $("#song_list tr:not(:first):not(.info)");
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
