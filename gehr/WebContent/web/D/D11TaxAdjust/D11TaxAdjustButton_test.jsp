<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustButton.jsp                                      */
/*   Description  : 연말정산공제신청 입력 header include                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005.11.17 lsa                                              */
/*   Update       : CSR ID:2013_9999 장애인코드 등록안한경우 Check              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    
    //소득공제신고서발행tab을 위함
    D11TaxAdjustMedicalRFC   rfc   = new D11TaxAdjustMedicalRFC();
    Vector print_medi_vt = new Vector();
    Vector medical_vt = new Vector();
    medical_vt = rfc.getMedical( user.empNo, targetYear );

    for( int i = 0 ; i < medical_vt.size() ; i++ ) {
        D11TaxAdjustMedicalData dataMd = (D11TaxAdjustMedicalData)medical_vt.get(i);

        if (!dataMd.OMIT_FLAG.equals("X")){ //연말정산삭제여부        
        print_medi_vt.addElement(dataMd);
        }
    }

    //기부금공제신고서발행tab을 위함
    D11TaxAdjustGibuRFC   rfcG   = new D11TaxAdjustGibuRFC();
    Vector print_gibu_vt = new Vector();
    print_gibu_vt = rfcG.getGibu( user.empNo, targetYear );  
  
    //신용카드 소득공제신고서발행tab을 위함
    D11TaxAdjustCardRFC   rfcC   = new D11TaxAdjustCardRFC();
    Vector print_card_vt = new Vector();
    print_card_vt = rfcC.getCard( user.empNo, targetYear,"1" );
    
    int simu_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_FROM,"-"));
    int simu_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_TOXX,"-"));
     
    D11TaxAdjustHouseHoleCheckRFC   rfcHC   = new D11TaxAdjustHouseHoleCheckRFC();
    D11TaxAdjustPersonCheckRFC      rfcPC   = new D11TaxAdjustPersonCheckRFC();
    String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
    String E_CHG =  rfcPC.getChk(  user.empNo, targetYear,begda,endda,""); //인적공제변동여부
	
    //********************* 2013.07.01 추가 *********************//
    String pdfYn = (String)session.getAttribute("pdfYn");
	//********************* 2013.07.01 추가 *********************//
    // 2002.12.04. 연말정산 확정여부 조회
    D11TaxAdjustYearCheckRFC rfc_c = new D11TaxAdjustYearCheckRFC();
    String c_flag = rfc_c.getO_FLAG( user.empNo, targetYear );
    
    String conFrimYn = "N";
    Vector retYN            = new Vector();
    retYN = ( new D11TaxAdjustScreenControlRFC() ).getFLAG( user.empNo ,targetYear,DataUtil.getCurrentDate() );   
    conFrimYn = (String)retYN.get(1); //회사별로 확정프로세스 사용여부가 옴 
                
    //CSR ID:2013_9999 장애인코드 등록안한경우 Check
    D11TaxAdjustPersonRFC    rfcPerson   = new D11TaxAdjustPersonRFC();   
    String  msg="";            
    Vector personVt = rfcPerson.getPerson( user.empNo, targetYear );   
    out.println("dd:"+ personVt.toString());
    for( int i = 0 ; i < personVt.size() ; i++ ){
        D11TaxAdjustPersonData dataPerson = (D11TaxAdjustPersonData)personVt.get(i);
    out.println("<br>HNDEE:-----"+ dataPerson.HNDEE );
    out.println("HNDCD:-----"+ dataPerson.HNDCD );
    out.println("ENAME:-----"+ dataPerson.ENAME );
      //  if (dataPerson.HNDEE.equals("X") && data.HNDCD.equals("")) {
      //      msg =dataPerson.ENAME+"에 대한 장애인 코드를 등록하세요.";
      //  }
    }
%>