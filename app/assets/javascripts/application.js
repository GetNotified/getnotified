// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require turbolinks
//= require_tree .

var mainMenu = (function() {

    var $listItems = [],
        $menuItems = [],
        $body = $( 'body' ),
        current = -1;

    function init() {
        $listItems = $( '#mainmenu > ul > li' );
        $menuItems = $listItems.children( 'a' );

        $menuItems.on( 'click', open );
        $listItems.on( 'click', function( event ) { event.stopPropagation(); } );
    }

    function open( event ) {

        var $item = $( event.currentTarget ).parent( 'li.has-submenu' ),
            idx = $item.index();
        if($item.length != 0){
            if( current !== -1 ) {
                $listItems.eq( current ).removeClass( 'mainmenu-open' );
            }

            if( current === idx ) {
                $item.removeClass( 'mainmenu-open' );
                current = -1;
            }
            else {
                $item.addClass( 'mainmenu-open' );
                current = idx;
                $body.off( 'click' ).on( 'click', close );
            }
            return false;
        }
        else window.location = $item.find('a').attr('href');
    }

    function close( event ) {
        $listItems.eq( current ).removeClass( 'mainmenu-open' );
        current = -1;
    }

    return { init : init };

})();

$(document).ready(function(){
    //Main menu Initialization
    mainMenu.init();

    //Initialize tooltips
    $('.show-tooltip').tooltip();

    $( window ).resize(function() {
        $('.col-footer:eq(0), .col-footer:eq(1)').css('height', '');
        var footerColHeight = Math.max($('.col-footer:eq(0)').height(), $('.col-footer:eq(1)').height()) + 'px';
        $('.col-footer:eq(0), .col-footer:eq(1)').css('height', footerColHeight);
    });
    $( window ).resize();

});