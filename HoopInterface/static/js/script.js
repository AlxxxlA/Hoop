// automatically hide alert messages
$(".alert").fadeTo(3000, 500).slideUp(500, function(){
    $(".alert").alert('close');
});
