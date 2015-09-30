$(function(){

    //Modal
    $(".close-modal-btn").click(function() {
        $('#set-modal').modal('hide');
    });

    $('#set-modal').on('show.bs.modal', function (e) {
        $('#key-modal').text($('.setKeyName').val());
        $('#value-modal').text($('.setValueName').val());
        $('#expt-modal').text($('.setExptName').val());
    });

    //Validate
    function validate(param, checkBrank, checkDigit) {
        if(typeof checkBrank === 'undefined') checkBrank = false;
        if(typeof checkDigit === 'undefined') checkDigit = false;

        if (checkBrank) {
            if (!param.match(/\S/g)) {
                return false;
            }
        }

        if ( checkDigit ) {
            if (!isFinite(parseInt(param, 10)) || parseInt(param, 10) < 0 ) {
                return false;
            }
        }

       return true;
    }

    $('.get-value-btn').click(function () {
        var key = $('.getKeyName').val();
        
        if (validate(key, true)) {
            getValue(key);
        } else {
            $('.get-result').html("<font color='red'> Please input Key name</font>");
        }
    })

    $('.set-value-btn').click(function () {
        var key = $('.setKeyName').val();
        var value = $('.setValueName').val();
        var expire = $('.setExptName').val();

        if (!validate(key, true) || !validate(value, true)) {
            $('.set-result').html("<font color='red'>Please input all parameters.</font>");
        } else if (!validate(expire, true, true)) {
            $('.set-result').html("<font color='red'>Expt Time should be digit & over 0</font>");
        } else {
            setValue(key, value, parseInt(expire, 10)) 
        }
    })

    $('.set-reset-btn').click(function () {
        resetSetParam();
    })

    $('.snapshot-btn').click(function () {
        var port = $('.snapPort').val();

        if (validate(port, true, true)) {
            $('.snap-explanation').text('Please execute below command on your ROMA server');
            $('.snap-command').css({"padding":"10px"});
            $('.snap-command').html("$ cd ${ROMA directory}<br>" + "$ bin/cpdb " + parseInt(port, 10));
            $('.snap-command-error').text('');
        } else {
            $('.snap-explanation').text('');
            $('.snap-command').css({"padding":"0"});
            $('.snap-command').text('');
            $('.snap-command-error').text("Port No. should be digit & over 0");
        }
    })

    function setApiEndpoint(action) {
        var protocol = location.protocol;
        var host = location.host;
        var webApiEndpoint = protocol+"//"+host+"/api/"+action;
        return webApiEndpoint;
    }

    function setValue(key, value, expire) {
        var webApiEndpoint = setApiEndpoint('set_value')

        $.ajax({
            url: webApiEndpoint,
            type: 'POST',
            beforeSend: function(xhr) {
                xhr.setRequestHeader(
                    'X-CSRF-Token',
                    $('meta[name="csrf-token"]').attr('content')
                )
            },
            data: {
                "key": key,
                "value": value,
                "expire": expire
            },
            dataType: 'text',
            cache: false,
        }).done(function(data){
            $('#set-modal').modal({
                show: true
            });

            resetSetParam();
        }).fail(function(error){
            alert("fail to access Gladiator Web API");
        });
    }

    function resetSetParam() {
        $('.setKeyName').val('');
        $('.setValueName').val('');
        $('.setExptName').val('');
        $('.set-result').text('');
    }

    function getValue(value) {
        var webApiEndpoint = setApiEndpoint('get_value')

        $.ajax({
            url: webApiEndpoint+"/"+value,
            type: 'GET',
            dataType: 'text',
            cache: false,
        }).done(function(data){
            if (data.match(/^null$/)) {
              $('.get-result').text("No data: "+value+ " don't have value.");
            } else {
              $('.get-result').text("Value: "+data);
            }

        }).fail(function(){
            alert("fail to access Gladiator Web API");
        });
    }

    //start to check snapshot
    if(document.getElementById('snapshotProgress')) {
        snapshotStatusCheck(gon.snapshoting);
    }

    function snapshotStatusCheck(instance) {
        var host = instance.split('_')[0]
        var port = instance.split('_')[1]

        var webApiEndpoint = setApiEndpoint('get_parameter')
        $('#lastSnapshotDate').text("-----");

        $.ajax({
            url: webApiEndpoint+"/"+host+"/"+port,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            eachStatus = data['storages[roma]']['storage.safecopy_stats'].replace(/\[|\]/g, "").split(', ');
            if (typeof gon.pastSnapshotDate === 'undefined') {
               gon.pastSnapshotDate = data['stats']['gui_last_snapshot'];
            }
            jQuery.each(eachStatus, function(index, value){
                $('#snapshotStatus'+index).text(value)
                if (value == ':safecopy_flushed') {
                    $('#snapshotStatus'+index).css({"background-color":"#c1fff1"})
                } else {
                    $('#snapshotStatus'+index).css({"background-color":"#ffffff"})
                }

            }); 
            checkFinish(data);

        }).fail(function(){
            alert("fail to access Gladiator Web API");
        });
    } //End of snapshotStatusCheck(instance)

    function checkFinish(data) {
        if (data['stats']['gui_run_snapshot'] == 'true') {
            setTimeout(function() { snapshotStatusCheck(gon.snapshoting) }, 1000);
        }else{
            if (data['stats']['gui_last_snapshot'] != gon.pastSnapshotDate) {
                $('#snapshotStatus').text("Finished!");
            } else {
                $('#snapshotStatus').css("color", "red");
                $('#snapshotStatus').text("Unexpected Error: STOP snapshot");
            }
            $('#lastSnapshotDate').text(data['stats']['gui_last_snapshot']);
            gon.snapshoting = null
            return;
        }
    }

});
