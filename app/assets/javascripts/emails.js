function updateEncryptCheckbox(text) {
  var checkbox = $('#email_encrypt');
  var enabledFor = checkbox.data('enabledFor').split(' ');
  var defaultFor = checkbox.data('defaultFor').split(' ');
  if (-1 < $.inArray(text, enabledFor)) {
    checkbox.removeAttr("disabled");
    checkbox.prop("checked", (-1 < $.inArray(text, defaultFor)) );
  }
  else
  {
    checkbox.prop("checked", false);
    checkbox.attr("disabled", "disabled");
  }
}

function warnEncryptCheckbox(val) {
  $('#prefers-encrypted').hide();
  $('#prefers-insecure').hide();
  var checkbox = $('#email_encrypt');
  var recipient = $('#email_to').val();
  var warnFor = checkbox.data('warnFor').split(' ');
  var defaultFor = checkbox.data('defaultFor').split(' ');
  if (-1 < $.inArray(recipient, warnFor)) {
    var defaultVal = (-1 < $.inArray(recipient, defaultFor));
    if (defaultVal != val) {
      if (defaultVal)
      {
        $('#prefers-encrypted').show();
      }
      else
      {
        $('#prefers-insecure').show();
      }
    }
  }
}

$(document).on('change', '#email_to', function(){
  updateEncryptCheckbox( $(this).val() );
});

$(document).on('change', '#email_encrypt', function(){
  warnEncryptCheckbox( $(this).prop('checked') );
});
