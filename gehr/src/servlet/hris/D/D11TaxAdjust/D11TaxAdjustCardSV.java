package servlet.hris.D.D11TaxAdjust;

import java.util.Vector;
import javax.servlet.http.*;

import org.apache.commons.lang.StringUtils;

import com.common.Global;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.A.A01SelfDetailLicenseData;
import hris.A.A17Licence.A17LicenceData;
import hris.A.rfc.A01SelfDetailLicenseRFC;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustCardSV.java
 * �������� - �ſ�ī��.���ݿ�����.����Ḧ ��û/����/��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * 2012 ������忩���߰� 2012/12/13
 * CSR ID:C20140106_63914 ����ī�忩�� �߰�   2013/12/05
 * @author lsa    2006/11/23
 *
 * update:          2018.01.07 cykim  [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� �� *
 *
 */
public class D11TaxAdjustCardSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//req.setCharacterEncoding("KSC5601");
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            String print_seq 		= (String) session.getAttribute("PNT_SEQ"); //@2014 �������� �ҵ�����Ű� seq �߰�
            Box         box     = WebUtil.getBox(req);
            //2016�������� sort  ���� start
            String sortField = box.get( "sortField" ,"SUBTY");   //sortFieldName or sortFieldIndex
            String sortValue = box.get( "sortValue" ,"desc"); //sortValue ex) desc, asc
            req.setAttribute( "sortField", sortField );
            req.setAttribute( "sortValue", sortValue );
            //2016�������� sort  ���� end
            D11TaxAdjustCardRFC   rfc   = new D11TaxAdjustCardRFC();
            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();

            Vector card_vt    = new Vector();
            String dest       = "";
            String jobid      = "";
            String targetYear = box.get("targetYear");
            String o_flag     = "";
            Vector cardData_vt = new Vector();
            String tab_gubun     = "";
            Vector yearCombo = new Vector();

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            tab_gubun = box.get("tab_gubun");


            if(jobid.equals("first")){

                cardData_vt = rfc.getCard( user.empNo, targetYear,tab_gubun );

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)*100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)*100 );

                    card_vt.addElement(data);
                }

                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );




                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue) ); //2016�������� sort  ����
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "tab_gubun" , tab_gubun  );
                req.setAttribute( "yearCombo", yearCombo);

                if( card_vt != null && card_vt.size() > 0 ) {    // ��ȸ
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardDetail.jsp";
                } else {                                         // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardBuild.jsp";
                }

                //ApLog
                ctrl = "12";

            } else if(jobid.equals("build")){

                int card_count = box.getInt("card_count");

                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // ���� ����

                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }

                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣ
                    data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    data.E_GUBUN  = box.get("E_GUBUN"+idx)  ;   // ����
                    data.GU_NAME  = box.get("GU_NAME"+idx)  ;   // ���и�
                    data.BETRG    = box.get("BETRG"+idx)   ;   // �ݾ�
                    data.BETRG_M  = box.get("BETRG_M"+idx)   ;   // �ݾ�
                    data.BETRG_O  = box.get("BETRG_O"+idx)   ;   // �ݾ�
                    data.BETRG_B  = box.get("BETRG_B"+idx)   ;   // �ݾ�
                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)/100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)/100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)/100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)/100 );
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // ����û�ڷ�
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 ������忩���߰�

                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 ����ī�忩�� �߰�
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 �������� ������ �ڵ�
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 �������� ������ �ؽ�Ʈ
                    */
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� end*/
                    card_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	/*[CSR ID:3569665] @2017 �������� ���Ⱓ ����*/
                    	val = new String[13];
	                    val[0] = data.SUBTY;
	                    val[1] = data.F_ENAME;
	                    val[2] = data.F_REGNO;
	                    val[3] = data.GUBUN;
	                    val[4] = data.E_GUBUN;
	                    val[5] = data.GU_NAME;
	                    val[6] = data.BETRG;
	                    val[7] = data.BETRG_M;
	                    val[8] = data.BETRG_O;
	                    val[9] = data.BETRG_B;
	                    val[10] = data.CHNTS;
	                    val[11] = data.TRDMK;
	                    val[12] = data.OMIT_FLAG;
	                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� start*/
	                    /*
	                    val[13] = data.EXPRD;
	                    val[14] = data.EXSTX;
	                    */
	                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� end*/
                    }
                }

                rfc.build( user.empNo, targetYear, card_vt ,tab_gubun);


                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustCardSV?targetYear="+targetYear+"&tab_gubun="+tab_gubun+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

                //ApLog
                ctrl = "11";
                cnt = String.valueOf(card_vt.size());

            } else if(jobid.equals("change_first")){

                cardData_vt = rfc.getCard( user.empNo, targetYear ,tab_gubun);

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)*100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)*100 );

                    card_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue)    );//2016�������� sort  ���� start
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "tab_gubun" , tab_gubun  );

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardChange.jsp";

                //ApLog
                ctrl = "12";

            } else if(jobid.equals("change")){
                int card_count = box.getInt("card_count");

                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // ���� ����

                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣ
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9

                    //ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    if ( box.get("GUBUN"+idx).equals("X")|| box.get("GUBUN"+idx).equals("9")){
                        data.GUBUN = 	"9";
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| box.get("GUBUN"+idx).equals("1")){
                        	data.GUBUN = 	"1";
                        }else{
                        	data.GUBUN = 	"2";
                        }
                    }

                    data.E_GUBUN  = box.get("E_GUBUN"+idx)  ;   // ����
                    data.GU_NAME  = box.get("GU_NAME"+idx)  ;   // ���и�
                    data.BETRG    = box.get("BETRG"+idx)   ;   // �ݾ�
                    data.BETRG_M    = box.get("BETRG_M"+idx)   ;   // �ݾ�
                    data.BETRG_O    = box.get("BETRG_O"+idx)   ;   // �ݾ�
                    data.BETRG_B    = box.get("BETRG_B"+idx)   ;   // �ݾ�
                    data.BETRG    = Double.toString(Double.parseDouble(data.BETRG)/100 );
                    data.BETRG_M    = Double.toString(Double.parseDouble(data.BETRG_M)/100 );
                    data.BETRG_O    = Double.toString(Double.parseDouble(data.BETRG_O)/100 );
                    data.BETRG_B    = Double.toString(Double.parseDouble(data.BETRG_B)/100 );
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // ����û�ڷ�
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 ������忩���߰�
                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 ����ī�忩�� �߰�
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 �������� ������ �ڵ�
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 �������� ������ �ؽ�Ʈ
                    */
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� end*/
                    card_vt.addElement(data);

                    //ApLog
                    if(i==0){
                    	/*[CSR ID:3569665] @2017 �������� ���Ⱓ ����*/
                    	val = new String[13];
	                    val[0] = data.SUBTY;
	                    val[1] = data.F_ENAME;
	                    val[2] = data.F_REGNO;
	                    val[3] = data.GUBUN;
	                    val[4] = data.E_GUBUN;
	                    val[5] = data.GU_NAME;
	                    val[6] = data.BETRG;
	                    val[7] = data.BETRG_M;
	                    val[8] = data.BETRG_O;
	                    val[9] = data.BETRG_B;
	                    val[10] = data.CHNTS;
	                    val[11] = data.TRDMK;
	                    val[12] = data.OMIT_FLAG;
	                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� start*/
	                    /*
	                    val[13] = data.EXPRD;
	                    val[14] = data.EXSTX;
	                    */
	                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� end*/
                    }

                }//for end

                rfc.build( user.empNo, targetYear, card_vt,tab_gubun );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustCardSV?targetYear="+targetYear+"&tab_gubun="+tab_gubun+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

                //ApLog
                ctrl = "11";
                cnt = String.valueOf(card_vt.size());
            } else if(jobid.equals("AddorDel")){

                int    card_count = box.getInt("card_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("rowCount");      //@v1.2

                //2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );
                for( int i = 0 ; i < card_count ; i++ ) {
                    D11TaxAdjustCardData data = new D11TaxAdjustCardData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // ���� ����
                    Logger.debug.println(this, "i:" + i + " data.SUBTY = " + data.SUBTY+" use_flag " +box.get("use_flag"+idx) );
                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    if( box.get("use_flag"+idx).equals("N") ) continue; //@v1.2

                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣ
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    //ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    if ( box.get("GUBUN"+idx).equals("X")|| box.get("GUBUN"+idx).equals("9")){
                        data.GUBUN = 	"9";
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| box.get("GUBUN"+idx).equals("1")){
                        	data.GUBUN = 	"1";
                        }else{
                        	data.GUBUN = 	"2";
                        }
                    }

                    data.E_GUBUN  = box.get("E_GUBUN"+idx) ;   // ����
                    data.GU_NAME  = box.get("GU_NAME"+idx) ;   // ���и�
                    data.BETRG    = box.get("BETRG"+idx)   ;   // �ݾ�
                    data.BETRG_M  = box.get("BETRG_M"+idx) ;   // �ݾ�
                    data.BETRG_O  = box.get("BETRG_O"+idx) ;   // �ݾ�
                    data.BETRG_B  = box.get("BETRG_B"+idx) ;   // �ݾ�
                    data.CHNTS    = box.get("CHNTS"+idx)   ;   // ����û�ڷ�
                    data.TRDMK    = box.get("TRDMK"+idx)   ;   // 2012 ������忩���߰�
                    data.CCTRA    = box.get("CCTRA"+idx)   ;    // CSR ID:C20140106_63914 ����ī�忩�� �߰�
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� start*/
                    /*
                    data.EXPRD = box.get("EXPRD_"+idx);//@2014 �������� ������ �ڵ�
                    data.EXSTX = box.get("EXSTX_"+idx);//@2014 �������� ������ �ؽ�Ʈ
                    */
                    /*[CSR ID:3569665] @2017 �������� ���Ⱓ ������ �ּ�ó�� end*/
                    card_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue));//2016�������� sort  ���� start
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount   );
                req.setAttribute( "tab_gubun" , tab_gubun  );

                if ( curr_job.equals("build") ) {    // �Է�ȭ��
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardBuild.jsp";
                } else {                             // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardChange.jsp";
                }

            } else if(jobid.equals("first_print")) {
                String print_page_name = WebUtil.ServletURL + "hris.D.D11TaxAdjust.D11TaxAdjustCardSV?jobid=print&targetYear="+"&tab_gubun="+tab_gubun;
                req.setAttribute( "print_page_name", print_page_name );
                dest =  WebUtil.JspURL + "common/printFrame2.jsp";

            } else if( jobid.equals("print") ){
                cardData_vt = rfc.getCard( user.empNo, targetYear,tab_gubun );

                for( int i = 0 ; i < cardData_vt.size() ; i++ ) {
                    D11TaxAdjustCardData data = (D11TaxAdjustCardData)cardData_vt.get(i);

                    data.BETRG = Double.toString(Double.parseDouble(data.BETRG)*100 );
                    data.BETRG_B = Double.toString(Double.parseDouble(data.BETRG_B)*100 );
                    data.BETRG_M = Double.toString(Double.parseDouble(data.BETRG_M)*100 );
                    data.BETRG_O = Double.toString(Double.parseDouble(data.BETRG_O)*100 );

                    card_vt.addElement(data);
                }
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "card_vt"   , replaceSort(card_vt,sortField,sortValue)    );//2016�������� sort  ���� start
                req.setAttribute( "tab_gubun" , tab_gubun  );
                req.setAttribute( "PNT_SEQ", print_seq);////@2014 �������� �ҵ�����Ű� seq �߰�
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustCardPrint.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            //ApLog ����
            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){
            	String subMenuNm = "�ſ�ī��";
            	if(tab_gubun.equals("2")){
            		subMenuNm = "�����";
            	}
            	ApLoggerWriter.writeApLog("��������", subMenuNm, "D11TaxAdjustCardSV", subMenuNm, ctrl, cnt, val, user, req.getRemoteAddr());
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
  //2016�������� sort  ���� start
    public  Vector replaceSort(Vector card_vt,String sortField, String sortValue)    throws GeneralException {

        if( sortField.equals("BETRG")||sortField.equals("BETRG_B")) {
        	card_vt = SortUtil.sort_num( card_vt, sortField, sortValue ); // Number
        } else {
        	card_vt = SortUtil.sort( card_vt, sortField, sortValue );     // String
        }
        return card_vt;
    }
  //2016�������� sort  ���� end

}
