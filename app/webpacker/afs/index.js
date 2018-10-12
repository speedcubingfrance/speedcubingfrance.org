// Setup all tooltips
$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip();
  $(".sort-me").tablesorter({
    dateFormat : "ddmmyyyy", // set the default date format
  });
})

window.afs = window.afs || {};

window.afs.computeSlug = function(title) {
  let normalized = title.normalize('NFD').replace(/[\u0300-\u036f]/g, "");
  normalized = normalized.replace(/['"]/g, "");
  normalized = normalized.replace(/ /g, "-");
  normalized = normalized.toLowerCase();
  return normalized;
}
