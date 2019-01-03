$.fetchOrgehData = function(author) {
    $.ajax({
        type : 'POST',
        url : '/common/getOrgehList.json',
        cache : false,
        dataType : 'json',
        data : {
        	author : author == null || author == '' ? 'M' : 'S'
        },
        async :false,
        success : function(response) {
            if(response.storeData.length > 0) {
                $.buildTree(response.storeData);
            }
        },
        error : function(jqXHR, textStatus, errorThrown ) {
            alert("Error\n" + textStatus);
        }
    });
}

$.buildTree = function(treeData) {
    var $nodeLvl0 = $('#treeData');
    var expandClass = 'folder';
    var $expandUl = $('<ul></ul>');
    var $li = $(document.createElement('li'));
    
    $.each(treeData, function(index, tree) {
        var nodeName = tree.OBJTXT;
        var nodeId = tree.OBJID;
        var nodeParentId = tree.UPOBJID;
        var nodeParentUlId = "ul_" + nodeParentId;
        var $cloneLi = $li.clone();
        
        $cloneLi.attr('id', nodeId).text(nodeName);
        if(tree.LOWERYN == 'X') {
            $cloneLi.addClass(expandClass);
            $cloneLi.append($expandUl.clone().attr('id', "ul_" + nodeId));
        }
        
        if(nodeParentId == '00000000') {
            $nodeLvl0.append($cloneLi);
        } else {
            var $parentUlNode = $('#' + nodeParentUlId);
            $parentUlNode.append($cloneLi);
        }
    });
    
    $('#tree').fancytree({
        /*selectMode: 3,*/
        clickFolderMode : 1,
        autoFocus : false,
        autoCollapse: true,
        activate: function(event, data){
            // 노드 선택시 부분 행위 ex)조직 상세조회, 조직정보 조회 등 작업
            $("#popLayerSearchOrgInTree").popup('hide');
            $("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
            setDeptID(data.node.key, data.node.title);
        }
    });
}

// 사원검색 button click event handler
$.bindSearchEmpHandler = function(author) {
    $('a[data-name="searchEmp"]').click(function() {

        var form = $('form[name="searchEmp"]'),
        t = form.find('input[type="text"][name="I_VALUE1"]'), v = t.val().trim();

        if ($('select[name="jobid"] option:selected').val() === 'ename') {
            if (!v) {
                alert("검색할 부서원 성명을 입력하세요.");
                t.focus();
                return false;
            }
            /*if (v.length < 2) {
                alert("검색할 성명을 한 글자 이상 입력하세요.");
                t.focus();
                return false;
            }*/
        } else {
            if (!v) {
                alert("검색할 부서원 사번을 입력하세요.");
                t.focus();
                return false;
            }
        }
        
        var params = form.serializeArray();
        params.push({name: "author", value: author == null || author == '' ? 'M' : 'S'});
        
        $.ajax({
            type : 'POST',
            url : '/common/searchPerson.json',
            cache : false,
            dataType : 'json',
            data : params,
            async :false,
            success : function(response) {
                $('#bodySearchEmp').empty();
                if(response.storeData.length > 1) {
                    $.each(response.storeData, function(i, o) {
                        o.PERNR = o.PERNR.replace(/^0{3}/, '');
                    });
                    $('#searchEmpTmpl').tmpl(response.storeData).appendTo('#bodySearchEmp');
                    $("#popLayerSearchEmp").popup('show');
                } else if(response.storeData.length == 1) {
                	setPersInfo(response.storeData[0].PERNR, response.storeData[0].ENAME);
                } else {
                    alert("검색결과가 없습니다.");
                    return false;
                }
            },
            error : function(jqXHR, textStatus, errorThrown ) {
                alert("Error\n" + textStatus);
            }
        });
    });
}

// 부서검색 button click event handler
$.bindButtonSearchDeptHandler = function(author) {
    $('a[data-name="searchOrg"]').click(function() {
        
        var form = $('form[name="searchOrg"]');
        var t = form.find('input[type="text"][name="txt_deptNm"]');
        if (!t.val().trim()) {
            alert("검색할 부서명을 입력하세요.");
            t.focus();
            return false;
        }
        
        $.ajax({
            type : 'POST',
            url : '/common/searchDeptName.json',
            cache : false,
            dataType : 'json',
            data : {
            	txt_deptNm : t.val().trim(),
            	author : author == null || author == '' ? 'M' : author 
            },
            async :false,
            success : function(response) {
                $('#bodySearchDept').empty();
                if(response.storeData.length > 0) {
                    $('#searchDeptTmpl').tmpl(response.storeData).appendTo('#bodySearchDept');
                    $("#popLayerSearchDept").popup('show');
                } else {
                    alert("검색결과가 없습니다.");
                    return;
                }
            },
            error : function(jqXHR, textStatus, errorThrown ) {
                alert("Error\n" + textStatus);
            }
        });
    });
}

// 조직도로 부서찾기 button click event handler
$.bindSearchOrgInTreeHandler = function() {
    $('a[data-name="searchOrgInTree"]').click(function() {
        
        $("#popLayerSearchOrgInTree").popup('show');
    });
}

// 하위조직포함 click event handler
$.bindIncludeSubOrgCheckboxHandler = function() {
    $('form[name="searchOrg"] input[type="checkbox"][name="includeSubOrg"]').click(function() {

        var form = $('form[name="searchOrg"]');
        if (!form.find('input[type="hidden"][name="DEPTID"]').val()) return;

        // 체크박스 선택시 자동검색
        setDeptID(form.find('input[type="hidden"][name="DEPTID"]').val(), form.find('input[type="text"][name="txt_deptNm"]').val());
    });
}

// 사원명 keydown event handler
$.bindEmpNameKeydownHandler = function() {
    $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').keydown(function(e) {
    	
        if (e.keyCode !== 13) return;

        $('a[data-name="searchEmp"]').click();
        
        return false;
    });
}

// 부서명 keydown event handler
$.bindDeptNameKeydownHandler = function() {
    $('form[name="searchOrg"] input[type="text"][name="txt_deptNm"]').keydown(function(e) {

        if (e.keyCode !== 13) return;

        $('a[data-name="searchOrg"]').click();
        
        return false;
    });
}