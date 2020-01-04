function viewPop(Url) {

    {

        var strJavaPop = "";
        strJavaPop = window.open(Url, 'popupNew', 'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
        strJavaPop.focus();
    }
}

function viewPop1200(Url) {

    {

        var strJavaPop = "";
        strJavaPop = window.open(Url, 'popupNew', 'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=1200,height=600,hotkeys=0');
        strJavaPop.focus();
    }
}


function RedirectParentTo(url) {

    window.top.location.href = url;
}

