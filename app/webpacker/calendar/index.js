import 'fullcalendar';
import _ from 'lodash';
import { API_COMP_URL, CALENDAR_EVENTS_URL } from 'afs/url_utils.js.erb';

var moment = require("moment");

window.afs = window.afs || {};

function postEventUpdate(event, delta, revertFunc) {
  let eventData = {};
  eventData["calendar_event"] = {
      id: event.id,
      name: event.title,
      public: event.public,
      kind: event.kind,
      start_time: event.start.format(),
      end_time: event.end.format(),
  };
  $.ajax({
    url: event.update_url,
    data: eventData,
    type: 'PATCH',
    beforeSend: function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name=csrf-token]').content);
    },
  }).fail(function() {
    alert("Failed to update the event, reverting");
    revertFunc();
  });
};

window.afs.initCalendar = function(can_manage_events = false) {
  if (!$("#calendar").hasClass("enable-calendar"))
    return;
  $("#calendar").fullCalendar({
    locale: "fr",
    eventDataTransform: externalEventToFcEvent,
    buttonText: {
      today:    'aujourd\'hui',
      month:    'mois',
      week:     'semaine',
      day:      'jour',
      list:     'liste'
    },
    header: {
      left:   'today',
      center: 'prev title next',
      right:  'prevYear,nextYear'
    },
    eventSources: [
      {
        events: getWcaCompetitions,
        color: "#28a745",
      },
      {
        events: getAFSEvents,
      },
    ],
    forceEventDuration: true,
    eventClick: function(event) {
      if (event.class === "competition" && event.url) {
        window.open(event.url);
        return false;
      } else {
        $.getScript(event.edit_url, function() {});
      }
    },
    eventDrop: postEventUpdate,
    eventResize: postEventUpdate,
    eventRender: function(event, element) {
      if (!can_manage_events || event.class === "competition" || event.public)
        return;

      // Give a visual feedback that the event is private
      $(element).find('.fc-title').each(function() {
        $(this).html(`<i class="fa fa-eye-slash"></i> ${event.title}`);
      });
    },
    selectable: can_manage_events,
    select: function(start, end) {
      $.getScript(`/calendar_events/new?start=${moment(start).format('YYYY-MM-DD')}&end=${moment(end).format('YYYY-MM-DD')}`, function() {});
      $("#calendar").fullCalendar('unselect');
    },
  });
  // Prevent the turbolink reload from enabling twice the calendar on the same element.
  $("#calendar").removeClass("enable-calendar");
}

window.afs.updateEvent = function(eventId, newEventData) {
  let eventData = $('#calendar').fullCalendar('clientEvents', eventId)[0];
  _.merge(eventData, newEventData);
  $('#calendar').fullCalendar('updateEvent', eventData, true);
}

window.afs.createEvent = function(newEventData) {
  $('#calendar').fullCalendar('renderEvent', newEventData);
}

window.afs.removeEvent = function(eventId) {
  $('#calendar').fullCalendar('removeEvents', [eventId]);
}


function getWcaCompetitions(start, end, timezone, callback) {
  let requestUrl = API_COMP_URL;
  let dateFormat = "YYYY-MM-DD";
  requestUrl += `?country_iso2=FR&start=${start.format(dateFormat)}&end=${end.format(dateFormat)}`;
  $.get(requestUrl, function(data) {
    callback(data);
  })
  .fail(function() {
    console.error("Could not fetch data from url '"+requestUrl+"'");
  });
}

function getAFSEvents(start, end, timezone, callback) {
  let requestUrl = CALENDAR_EVENTS_URL;
  $.get(requestUrl, function(data) {
    callback(data);
  })
  .fail(function() {
    console.error("Could not fetch data from url '"+requestUrl+"'");
  });
}

function externalEventToFcEvent(eventData) {
  if (eventData.class === "competition") {
    eventData.title = eventData.name;
    eventData.start = eventData.start_date;
    eventData.allDay = true;
    let endDate = moment(eventData.end_date);
    // 'end' is an *exclusive* end date, meaning we need to add one
    endDate.add(1, 'd');
    eventData.end = endDate.format("YYYY-MM-DD");
  }
  return eventData;
}
