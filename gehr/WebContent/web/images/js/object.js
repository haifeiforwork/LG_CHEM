 /**
 *  Copyright(���۱�) Do Not Erase This Comment!!! (�� �ּ����� ������ ����)
 *  
 *  In the case of modifing source, you should email to all the authors 
 *  in the below author list for information ( such as all set of modified sources,
 *  information of modifications, etc..)
 *  If provided modifications are proved reasonable, we may update imgbutton.htc 
 *  reflecting your ideas on modifications
 *  Furthermore, if your modifications are proved valuable, it is possible to add 
 *  your information on the authors list under deliberation.
 *
 *  (Caution!) DO NOT redistribute without permission. 
 *             Distribution to outside of LG CNS is NOT permitted. 
 *
 *  �ҽ��� �����Ͽ� ����ϴ� ��� �Ʒ��� ���� ����Ʈ�� ��ϵ� ��� �����ڿ���
 *  ����� �ҽ� ��ü�� ����� ������ mail�� �˷��� �Ѵ�.
 *  �����ڴ� ������ �ҽ��� �����ϴٰ� �ǴܵǴ� ��� �ش� ������ �ݿ��� �� �ִ�.
 *  �߿��� Idea�� �����Ͽ��ٰ� �ǴܵǴ� ��� �����Ͽ� ���� List�� �ݿ��� �� �ִ�.
 *  
 *  (����!) �������� ������� ����� �� �� ������ LG CNS �ܺη��� ������ �Ͽ����� �ȵȴ�.
 *  
 **
 * AUTHORS LIST       E-MAIL                   HOMEPAGE
 * TK Shin            tkyushin@lgcns.com       http://www.javatoy.net
 * 
 **
 ** MODIFICATION HISTORY
 ** DATE       Version    DEVELOPER        DESCRIPTION
 ** 2006/02/06 0.8        Shin Tack Kyu    Initial Release
 **
 ** Detail Build HISTORY
 ** DATE        BUILD  DESCRIPTION
 ** 2006/02/06 a100   alpha Release
 */
function __ws__(id)
{
   document.write(id.innerHTML);
   id.id =  "";
   
} 

//************************************************************************
// ��ȭ���� String�� ��ȣȭ �ϱ� ���� �Լ� No.01
// �ۼ��� : ������
// ���ϸ� : fnLgaEncrypt01.js
// �ۼ��� : 2003.08.20
// ����   : 1.0 
// ���ǻ��� : pwd ������ ��� ��ȣȭ Password�� �����ؾ� ��. 
//   
<!-- Begin
//************************************************************************
// Copyright 2001 by Terry Yuen.
// Email: kaiser40@yahoo.com
//
// Examples:
// var secret = encrypt("My surprise will consist of ....");
// document.writeln(secret);
//************************************************************************


function encrypt(str) {

  var pwd = "LGACHEM02"   //mask���� �Ұ�!!! (Decrypt�� ���ƾ� ��.)

  if(pwd == null || pwd.length <= 0) {
    //alert("Please enter a password with which to encrypt the message.");
    return null;
  }
  var prand = "";
  for(var i=0; i<pwd.length; i++) {
    prand += pwd.charCodeAt(i).toString();
  }
  var sPos = Math.floor(prand.length / 5);
  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
  var incr = Math.ceil(pwd.length / 2);
  var modu = Math.pow(2, 31) - 1;
  if(mult < 2) {
    //alert("Algorithm cannot find a suitable hash. Please choose a different password. \nPossible considerations are to choose a more complex or longer password.");
    return null;
  }
  var salt = Math.round(Math.random() * 1000000000) % 100000000;
  prand += salt;
  while(prand.length > 10) {
    prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
  }
  prand = (mult * prand + incr) % modu;
  var enc_chr = "";
  var enc_str = "";
  for(var i=0; i<str.length; i++) {
    enc_chr = parseInt(str.charCodeAt(i) ^ Math.floor((prand / modu) * 255));
    if(enc_chr < 16) {
      enc_str += "0" + enc_chr.toString(16);
    } else enc_str += enc_chr.toString(16);
    prand = (mult * prand + incr) % modu;
  }
  salt = salt.toString(16);
  while(salt.length < 8)salt = "0" + salt;
  enc_str += salt;
  return enc_str;
}
//-->