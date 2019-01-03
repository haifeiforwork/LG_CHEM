
						function getProvince(tem, pernr, state1) {
						
							var url = '/servlet/servlet.hris.A.A14Bank.A14BankAjax';
							var pars = 'code=' + tem+"&PERNR="+pernr +"&STATE1="+state1;
							//var myAjax = new $.ajax(url,{method: 'get',parameters: pars,onComplete: showResponse});
							$.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
						}
						
						function showResponse(originalRequest)
						{
							//put returned XML in the textarea
							if (originalRequest !=''){
								var arr= new Array();
								arr=originalRequest.split('|');
	// 							$('province').innerHTML = unescape(arr[0]);
								$('#province').html( unescape(arr[0]));
								 // calculate(); //없음ksc
								$('#province').addClass("required");
							}
						}
						
						