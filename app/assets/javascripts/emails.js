(function(){

  function checkbox(){
    return $('#email_encrypt');
  }

  function isEnabledFor(recipient){
    if (checkbox()) {
      var recipients = checkbox().data('enabledFor').split(' ');
      return (-1 < $.inArray(recipient, recipients))
    }
  }

  function isDefaultFor(recipient){
    if (checkbox()) {
      var recipients = checkbox().data('defaultFor').split(' ');
      return (-1 < $.inArray(recipient, recipients))
    }
  }

  function isWarnFor(recipient){
    if (checkbox()) {
      var recipients = checkbox().data('warnFor').split(' ');
      return (-1 < $.inArray(recipient, recipients))
    }
  }

  function updateEncryptCheckbox(recipient) {
    $('#prefers-encrypted').hide();
    $('#prefers-insecure').hide();
    if (isEnabledFor(recipient)) {
      checkbox().removeAttr("disabled");
      checkbox().prop("checked", (isDefaultFor(recipient)) );
    }
    else
    {
      checkbox().prop("checked", false);
      checkbox().attr("disabled", "disabled");
    }
  }

  function warnEncryptCheckbox(val) {
    $('#prefers-encrypted').hide();
    $('#prefers-insecure').hide();
    var recipient = $('#email_to').val().toLowerCase();
    if (isWarnFor(recipient)) {
      var defaultVal = isDefaultFor(recipient);
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
    updateEncryptCheckbox( $(this).val().toLowerCase() );
  });

  $(document).on('change', '#email_encrypt', function(){
    warnEncryptCheckbox( $(this).prop('checked') );
  });
}).call(this);
