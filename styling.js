$('.long-list').each(function () {
    $(this).children(':gt(9)').hide().last().after(
        $('<a />').attr('href', '#').addClass('more-button').text('Show more').click(function () {
            var a = this;
            $('.image-list li:not(:visible):lt(5)').fadeIn(function () {
                if ($('.image-list li:not(:visible)').length == 0) $(a).remove();
            });
            return false;
        })
    );
});

$(function(){

    var minimized_elements = $('p.abstract');
    var max_length = 250;

    minimized_elements.each(function(){
        var t = $(this).text();
        if(t.length < max_length)
            return;
        $(this).html(
            t.slice(0, max_length) +
            '<span>... </span><a href="#" class="more">More</a>' +
            '<span style="display:none;">' +
            t.slice(max_length,t.length) +
            ' <a href="#" class="less">Less</a></span>'
        );
    });

    $('a.more', minimized_elements).click(function(event){
        event.preventDefault();
        $(this).hide().prev().hide();
        $(this).next().show();
    });

    $('a.less', minimized_elements).click(function(event){
        event.preventDefault();
        $(this).parent().hide().prev().show().prev().show();
    });

});
