$(window).load(function() {

    //for past version
    if ($('.recover-restriction-msg')[0]) {
        $('#recover-button').css({"background-color":"grey", "border":"none"});
    }
    if ($('.restriction-health-button')[0]) {
        $('.table-contents td:nth-of-type(3)').css({"background-color":"silver", "color":"#696969"});
    }

    //Just Booting
    if (gon.just_booting) {
        var element = $('.table-contents');
        element.css("color", "#A9A9A9");
        element.html('<tr><td colspan="8">Now ROMA is booting, please reload after a few seconds later.</td></tr>')
    }

    //Modal
    $('#rbalse-modal').on('show.bs.modal', function (e) {
        $("#rbalse-hidden-value").attr("value", e.relatedTarget.name);
    })

    $('#rbalse-modal-after-release').on('show.bs.modal', function (e) {
        $("#rbalse-hidden-value-after-release").attr("value", gon.host+"_"+gon.port);
    })

    $('#release-modal').on('show.bs.modal', function (e) {
        $("#release-hidden-value").attr("value", e.relatedTarget.name);
    })

    $("#repetitionCheck").click(function() {
        if($(this).is(':checked')) {
            $('#repetition-modal').modal({
                show: true,
                keyboard: false
            })
        }
    });

    $(".activate-repetition-btn").click(function() {
        $('#repetition-modal').modal('hide');
    });

    $(".deactivate-repetition-btn").click(function() {
        $('#repetitionCheck').attr("checked", false);
        $('#repetition-modal').modal('hide');
    });

    //Table sorter
    $('table.cluster-table').tablesorter({
        theme: 'default',
        sortList: [[0,0]],
        widthFixed: true,
        widgets: ["filter"], 
        headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }, 5: { filter: false },  6: { filter: false, sorter: false }, 7: { filter: false }},
        widgetOptions : { 
          filter_reset : 'button.reset-filter',
          filter_cssFilter : 'tablesorter-filter', 
          filter_functions : {
            2 : true
          }
        } 
    });

    //start to check extra process(recover)
    if(document.getElementById('extra-process-recover')) {
        calcProgressRate('recover');
    }

    //start to check extra process(release)
    if(document.getElementById('extra-process-release')) {
        calcProgressRate('release');
    }

    //start to check extra process(join)
    if(document.getElementById('extra-process-join')) {
        calcProgressRate('join');
    }

    function calcProgressRate(process) {
        var webApiEndPoint
        var instanceName
        var primaryVnodes
        var secondaryVnodes
        var progressRate
        var host
        var protocol

        protocol = location.protocol;
        host = location.host;
        webApiEndPoint = protocol+"//"+host+"/api/get_routing_info"

        $.ajax({
            url: webApiEndPoint,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){

            for(instanceName in data){
                if (data[instanceName]["status"] != "inactive") {

                    primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
                    secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
                    startPrimaryVnodes   = gon.routing_info[instanceName]["primary_nodes"];
                    startSecondaryVnodes = gon.routing_info[instanceName]["secondary_nodes"];

                    //set vnodes count
                    if (primaryVnodes < startPrimaryVnodes) {
                        color_primary = "red"
                        icon_primary  = 'arrow-down'
                    }else if (primaryVnodes > startPrimaryVnodes) {
                        color_primary = "blue"
                        icon_primary  = 'arrow-up'
                    }else{
                        color_primary = ""
                        icon_primary  = ''
                    }

                    if (secondaryVnodes < startSecondaryVnodes) {
                        color_secondary = "red"
                        icon_secondary  = 'arrow-down'
                    }else if (secondaryVnodes > startSecondaryVnodes) {
                        color_secondary = "blue"
                        icon_secondary  = 'arrow-up'
                    }else{
                        color_secondary = ""
                        icon_secondary  = ''
                    }

                    instance = instanceName.match(/\d/g).join("");
                    //for primary nodes
                    $('#primary-nodes-'+instance).css("color", color_primary)
                    $('#primary-nodes-'+instance).html(primaryVnodes+'<span><i class="icon-'+icon_primary+'"></i></span>')
                    //for secondary nodes
                    $('#secondary-nodes-'+instance).css("color", color_secondary)
                    $('#secondary-nodes-'+instance).html(secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>')

                    if (instanceName == gon.host+"_"+gon.port) {
                        $('#short-vnodes-cnt').text(data[instanceName]["short_vnodes"]);

                        progressBarSet(data[instanceName], process);
                        checkFinish(data[instanceName], process);
                    }
                }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate(process)

    function progressBarSet(data, process) {
        switch (process) {
            case "release":
                primaryVnodes   = parseInt(data["primary_nodes"]);
                secondaryVnodes = parseInt(data["secondary_nodes"]);
                progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/gon.denominator)) * 1000) /10
                $('#extra-progress-bar').css("width",progressRate + "%");
                $('#extra-bar-rate').text(progressRate+ "% Complete");
                break;

            case "join":
                $('#extra-progress-bar').css("width",100 + "%");
                $('#extra-bar-rate').text("Now executing");
                break;

            case "recover":
                shortVnodes = data["short_vnodes"];
                progressRate = Math.round(((gon.denominator - shortVnodes)/gon.denominator)*1000) / 10
                $('#extra-progress-bar').css("width",progressRate + "%");
                $('#extra-bar-rate').text(progressRate+ "% Complete");
                break;
        }
    }

    function checkFinish(data, process) {
        switch (process) {
            case "release":
                primaryVnodes   = parseInt(data["primary_nodes"]);
                secondaryVnodes = parseInt(data["secondary_nodes"]);
                progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/gon.denominator)) * 1000) /10
                if (progressRate == 100) {
                    $('#extra-bar-rate').text("Finished!");
                    setTimeout(function() { confirmRbalse() }, 1000);
                }else{
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;

            case "join":
                if (data["status"] != "join") {
                    setTimeout(function() { redirectClusterPage() }, 3000);
                }else{
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;

            case "recover":
                shortVnodes = data["short_vnodes"];
                progressRate = Math.round(((gon.denominator - shortVnodes)/gon.denominator)*1000) / 10
                if (progressRate == 100) {
                    $('#extra-bar-rate').text("Finished!");
                    setTimeout(function() { redirectClusterPage() }, 3000);
                }else{
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;
        }
    }

    function confirmRbalse(){
        $('#rbalse-modal-after-release').modal('show')
    }

    function redirectClusterPage(protocol, host){
        if(typeof protocol === 'undefined') protocol = location.protocol;
        if(typeof host === 'undefined') host = location.host;
        window.location.assign(protocol+"//"+host+"/cluster/index");
    }

    //join command generator
    $('.join-generate-btn').click(function () {
        var newHost = $('#newHost').val();
        var newPort = $('#newPort').val();
        var currentHost = $('#currentHost').val();
        var currentPort = $('#currentPort').val();
        var configPath = $('#configPath').val();
        if ($("#repetitionCheck").prop('checked')) {
            var repetitionOption = "--enabled_repeathost"
        }
        else {
            var repetitionOption = ""
        }

        var params =  { 'newHost' : newHost, 'currentHost': currentHost, 'newPort' : newPort, 'currentPort': currentPort, 'configPath': configPath };
        if ( !currentHost || !currentPort ) {
            $('.join-explanation').css({"color":"#ff0000"});
            $('.join-explanation').text("Irregular situation happened, please login again.");
        } else if (checkParams(params)) {
            generateJoinCommand(newHost, newPort, currentHost, currentPort, configPath, repetitionOption)
        } else {
            resetResult();
        }
    })

    function generateJoinCommand(newHost, newPort, currentHost, currentPort, configPath, repetitionOption) {
        $('.join-explanation').text("Please execute below command on your ROMA server.");
        $('.join-command').css({"padding":"10px"});
        $('.join-command').html(
            "$ cd ${ROMA directory}/ruby/server<br>" + 
            "$ bin/romad "+newHost+" -p "+newPort+" -d -j "+currentHost+"_"+currentPort+" --config "+configPath+" "+repetitionOption
        );
    }

    function resetResult() {
        $('.join-explanation').text("");
        $('.join-command').css({"padding": "0"});
        $('.join-command').text("");
    }

    function checkParams(params) {
        checkParams.result = true

        jQuery.each(params, function(key, value) {
            var checkBrank = true;
            var checkDigit = true
            var checkMultiByte = true

            if (key.match(/^(newHost|currentHost|configPath)$/)) {
                checkDigit = false;
            }

            if (res = validate(value, checkBrank, checkDigit, checkMultiByte)) {
                $('.'+key).css({"color":"red"});
                switch (res) {
                    case 'nonDigit':
                        $('.'+key).text("This param should be digit & over 0");
                        break;
                    case 'brank':
                        $('.'+key).text("This param can't be brank");
                        break;
                    case 'unexpected':
                        $('.'+key).text("This param include unexpected character.");
                        break;
                }
                checkParams.result = false
            } else {
                //remove error message
                $('.'+key).text('');
            }
        });

        if ( duplicateCheck(params) ) {
            $('.newHost').css({"color":"#ff0000"});
            $('.newHost').text(params['newHost']+"_"+params['newPort']+" is already being used in cluster.");
            $('.newPort').css({"color":"#ff0000"});
            $('.newPort').text(params['newHost']+"_"+params['newPort']+" is already being used in cluster.");
            checkParams.result = false
        }

        if (checkParams.result) {
            return true;
        } else {
            return false;
        }
    }

    function validate(param, checkBrank, checkDigit, checkMultiByte) {
        if ( checkBrank ) {
            if (!param.match(/\S/g)) { return 'brank'; }
        }
        if ( checkDigit ) {
            if (!isFinite(parseInt(param, 10)) || parseInt(param, 10) < 0 ) { return 'nonDigit'; }
        }
        if ( checkMultiByte ) {
            if ( !param.match(/^[a-zA-Z0-9\/\._\-]+$/)) { return 'unexpected'; }
        }
       return false;
    }

    function duplicateCheck(params) {
        var newInstance = params['newHost']+"_"+params['newPort'];    
        if ( $.inArray(newInstance,gon.active_routing_list) >= 0 ) {
            return true;
        }
        return false;
    }

    // accordion panel(join)
    $("dd").css("display","none");

    $(".join-command-generate .join-command-title").click(function(){
        if($("+dd",this).css("display")=="none"){
            $("dd").slideUp("slow");
            $("+dd",this).slideDown("slow");
            $(".accordion-status").html("<i class='icon-chevron-down'></i>");
        }else{
            $("dd").slideUp("slow");
            $(".accordion-status").html("<i class='icon-chevron-right'></i>");
        }
    });


});
