//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

// js routes wrapper initialization
var _routes = {};

var listenedSongsIds = [];
var listenedSongsIndex = 0;
var reset = false;

$(document).ready(function(){

  // prevent select text in song list rows (it was happening double clicking)
  jQuery("#song_list tr").mousedown(function(e){ e.preventDefault(); });

	$("#song_list tr:not(#thead)").dblclick(function () {
    play($(this));
	});

  $('#next_song-js').click(function() {
    next_row_song = nextSongRow(playingSongRow());
    play(next_row_song);
  });

  $('#previous_song-js').click(function() {
    playPrevious();
  });

  $('#random-js').click(function() {
    if (isRandomSelected()) {
      $(this).removeClass("btn-info");
      $(this).addClass("btn-default");
    } else {
      $(this).removeClass("btn-default");
      $(this).addClass("btn-info");
    }

    toggleReset();
  });
});

function play(song_row, previous = false) {
  id = song_row.data('song-id');

  $.get(_routes['playSongsPathJS'], { id: id })
    .done(function() {
      $(".info").removeClass("info")
      song_row.addClass("info");

      if (!previous) addToListenedSongs(id)
      playNextAtTheEnd();
    });
}

function playPrevious() {
  if (isFirstListenedSong()) {
    play(firstSongRow);
  } else {
    listenedSongsIndex -= 1;
    previousId = listenedSongsIds[listenedSongsIndex - 1];
    previousSongRow = findSongRowById(previousId);
    play(previousSongRow, true);
  }
}

function playNextAtTheEnd() {
  var audio = document.getElementById('audio');
  audio.addEventListener('ended',function() {
    next_row_song = nextSongRow(playingSongRow());
    play(next_row_song);
  });
}

function nextSongRow(song_row) {
  if (reset || isLastListenedSong()) {
    if (reset) resetListenedSongs();
    return isRandomSelected() ? randomRow() : song_row.next()
  } else {
    return nextListenedSongRow()
  }
}

function playingSongId() {
  return $('#audio').data('song-id');
}

function playingSongRow() {
  return $('#song_' + playingSongId());
}

function firstSongRow() {
  return $("#song_list tr:not(#thead):first");
}

function findSongRowById(id) {
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
  return $("#song_list tr:not(#thead):not(.info)");
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function addToListenedSongs(song_id) {
  if (isLastListenedSong()) {
    listenedSongsIds.push(song_id);
  }

  listenedSongsIndex += 1;
}

function isFirstListenedSong() {
  return listenedSongsIndex == 1;
}

function isLastListenedSong() {
  return listenedSongsIds.length == listenedSongsIndex;
}

function nextListenedSongRow() {
  nextId = listenedSongsIds[listenedSongsIndex];
  return findSongRowById(nextId);
}

function resetListenedSongs() {
  listenedSongsIds = [];
  listenedSongsIndex = 0;
  reset = false;
}

function toggleReset() {
  if (reset) {
    reset = false;
  } else {
    reset = true;
  }
}
