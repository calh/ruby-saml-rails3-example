$(document).ready(function()
{
    $('.qtip').each(function()
    {
  $(this).qtip({
      
     content: $(this).attr('tooltip'),
  style: 'cream'
       });
    });
});
