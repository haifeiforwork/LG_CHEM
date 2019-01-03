package servlet.hris.D.D11TaxAdjust;

import java.util.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustGibuSV.java
 * �������� - Ư������ ��αݸ� ��û/����/��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2005/11/17    
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914  
 * 2018/01/05 rdcamel [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
 */
public class D11TaxAdjustGibuSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
        	//ApLog
        	String ctrl = "";
        	String cnt = "0";
        	String[] val = null;
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            String print_seq 		= (String) session.getAttribute("PNT_SEQ"); //@2014 �������� �ҵ�����Ű� seq �߰�
            Box         box     = WebUtil.getBox(req);

            D11TaxAdjustGibuRFC   rfc   = new D11TaxAdjustGibuRFC();
            D11TaxAdjustYearCheckRFC rfc_o = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            
            D11TaxAdjustGibuCarriedRFC rfc_carried = new D11TaxAdjustGibuCarriedRFC();//[CSR ID:3569665]
           

            Vector gibu_vt    = new Vector();
            Vector gibuCarried_vt = new Vector();
            String dest       = "";
            String jobid      = "";
            String targetYear = box.get("targetYear"); 
            String o_flag     = "";
            Vector gibuData_vt = new Vector();

            String GUBUN="";
            //�븮 ��û �߰�
            String PERNR = box.get("PERNR"); 
            
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            Logger.debug.println(this,"PERNR:"+PERNR+"phonenumdata:"+  phonenumdata.toString());
            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            
            gibuCarried_vt = rfc_carried.getGibuCarried(PERNR, targetYear);//[CSR ID:3569665]

            if(jobid.equals("first")){

                gibuData_vt = rfc.getGibu( PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT    = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );
                    data.DONA_DEDPR    = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 );  // @2011 ������� ������ �ݾ�

                    gibu_vt.addElement(data);
                }

//              2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( PERNR, targetYear );

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]
                
                if( gibu_vt != null && gibu_vt.size() > 0 ) {    // ��ȸ
            	
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuDetail.jsp";
                } else {                                         // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuBuild.jsp";
                }
                //ApLog
                ctrl = "12";
            } else if(jobid.equals("build")){

                int gibu_count = box.getInt("gibu_count"); 

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);

                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // ��α�����

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }

                    data.SUBTY  = box.get("SUBTY"+idx) ;          // ���� ���� CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣCSR ID:1361257
                    //data.GUBUN      = box.get("GUBUN"+idx);       // ����
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    
                    GUBUN = box.get("GUBUN"+idx);
                    // C20140106_63914 ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }
                    
                    
                    data.DONA_YYMM  = box.get("DONA_YYMM"+idx);   // ��ο���
                    data.DONA_DESC  = box.get("DONA_DESC"+idx);   // ��αݳ���
                    data.DONA_NUMB  = box.get("DONA_NUMB"+idx);   // ����ڵ�Ϲ�ȣ
                    data.DONA_COMP  = box.get("DONA_COMP"+idx);   // ��ȣ
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2����û��������
                    data.DONA_SEQN  = box.get("DONA_SEQN"+idx);   // ��α� �Ϸù�ȣ
                    data.DONA_AMNT  = box.get("DONA_AMNT"+idx);   // �ݾ�
                    data.DONA_AMNT  = Double.toString(Double.parseDouble(data.DONA_AMNT)/100 );
                    data.DONA_DEDPR  = box.get("DONA_DEDPR"+idx);   //@2011 ������� ������ �ݾ�
                    data.DONA_DEDPR = Double.toString(Double.parseDouble(data.DONA_DEDPR)/100 );  // @2011 ������� ������ �ݾ�
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  �̿����� ����
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  �̿�����üũ 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    gibu_vt.addElement(data);
                    //ApLog
                    if(i==0){
                    	val = new String[16];
	                    val[0] = data.DONA_CODE;
	                    val[1] = data.SUBTY;
	                    val[2] = data.F_ENAME;
	                    val[3] = data.F_REGNO;
	                    val[4] = data.GUBUN;
	                    val[5] = data.DONA_YYMM;
	                    val[6] = data.DONA_DESC;
	                    val[7] = data.DONA_NUMB;
	                    val[8] = data.DONA_COMP;
	                    val[9] = data.CHNTS;
	                    val[10] = data.DONA_SEQN;
	                    val[11] = data.DONA_AMNT;
	                    val[12] = data.DONA_DEDPR;
	                    val[13] = data.DONA_CRVYR;
	                    val[14] = data.DONA_CRVIN;
	                    val[15] = data.OMIT_FLAG;
                    }
                }

                Logger.debug.println(this, " gibu_vt:"+  gibu_vt.toString());
                rfc.build( PERNR, targetYear, gibu_vt );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?targetYear="+targetYear+"&PERNR="+PERNR+"';";
                
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog                
                ctrl = "11";
                cnt = String.valueOf(gibu_vt.size());
            } else if(jobid.equals("change_first")){

                gibuData_vt = rfc.getGibu(PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT    = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );

                    data.DONA_DEDPR    = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 );
                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]

                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuChange.jsp";
                //ApLog                
                ctrl = "12";
            } else if(jobid.equals("change")){
                int gibu_count = box.getInt("gibu_count");

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);

                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // ��α�����

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }
                    data.SUBTY  = box.get("SUBTY"+idx) ;          // ���� ���� CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣCSR ID:1361257

                    Logger.debug.println(this, " GUBUN = " +idx + "GUBUN:"+box.get("GUBUN"+idx)) ;
                    
                    //data.GUBUN         = box.get("GUBUN"+idx)        ;   // ����
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    
                   // data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":	box.get("GUBUN"+idx).equals("1")?"1":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9

                    GUBUN = box.get("GUBUN"+idx);
                    //ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }

                    Logger.debug.println(this, "[[[ ===GUBUN:"+GUBUN+"===== idx= " +idx + "data.GUBUN:"+data.GUBUN) ;

                    Logger.debug.println(this, "[[[ idx= " +idx + "box.GUBUN:"+box.get("GUBUN"+idx)) ;
                    Logger.debug.println(this, "[[[ idx= " +idx + "box.GUBUN_SAP:"+box.get("GUBUN_SAP"+idx)) ;
                    data.DONA_YYMM     = box.get("DONA_YYMM"+idx)    ;   // ��ο���
                    data.DONA_DESC     = box.get("DONA_DESC"+idx)    ;   // ��αݳ���
                    data.DONA_NUMB     = box.get("DONA_NUMB"+idx)    ;   // ����ڵ�Ϲ�ȣ
                    data.DONA_COMP     = box.get("DONA_COMP"+idx)    ;   // ��ȣ
                    data.CHNTS         = box.get("CHNTS"+idx)        ;   // @v1.2����û��������
                    data.DONA_SEQN     = box.get("DONA_SEQN"+idx);   // ��α� �Ϸù�ȣ
                    data.DONA_AMNT     = box.get("DONA_AMNT"+idx)    ;   // �ݾ�
                    data.DONA_AMNT     = Double.toString(Double.parseDouble(data.DONA_AMNT)/100 );
                    data.DONA_DEDPR     = box.get("DONA_DEDPR"+idx)    ;   // @2011 ������� ������ �ݾ� 
                    data.DONA_DEDPR     = Double.toString(Double.parseDouble(data.DONA_DEDPR)/100 );// @2011 ������� ������ �ݾ� 
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  �̿����� ����
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  �̿�����üũ 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    gibu_vt.addElement(data);
                    //ApLog
                    if(i==0){
                    	val = new String[16];
	                    val[0] = data.DONA_CODE;
	                    val[1] = data.SUBTY;
	                    val[2] = data.F_ENAME;
	                    val[3] = data.F_REGNO;
	                    val[4] = data.GUBUN;
	                    val[5] = data.DONA_YYMM;
	                    val[6] = data.DONA_DESC;
	                    val[7] = data.DONA_NUMB;
	                    val[8] = data.DONA_COMP;
	                    val[9] = data.CHNTS;
	                    val[10] = data.DONA_SEQN;
	                    val[11] = data.DONA_AMNT;
	                    val[12] = data.DONA_DEDPR;
	                    val[13] = data.DONA_CRVYR;
	                    val[14] = data.DONA_CRVIN;
	                    val[15] = data.OMIT_FLAG;
                    }
                }
                
                Logger.debug.println(this, "CHANGE gibu_vt:"+  gibu_vt.toString());
                
                rfc.build( PERNR, targetYear, gibu_vt );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?targetYear="+targetYear+"&PERNR="+PERNR+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                //ApLog                
                ctrl = "11";
                cnt = String.valueOf(gibu_vt.size());
            } else if(jobid.equals("AddorDel")){

                int    gibu_count = box.getInt("gibu_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("gibu_count");

//              2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( PERNR, targetYear );

                for( int i = 0 ; i < gibu_count ; i++ ) {
                    D11TaxAdjustGibuData data = new D11TaxAdjustGibuData();
                    String idx = Integer.toString(i);
          
                    data.DONA_CODE = box.get("DONA_CODE"+idx)   ;   // ��α�����

                    if ( data.DONA_CODE.equals("") || data.DONA_CODE.equals(" ") ) {
                        continue;
                    }

                    if( box.get("use_flag"+idx).equals("N") ) continue; //@v1.2    
                    
                    
                    data.SUBTY  = box.get("SUBTY"+idx) ;          // ���� ���� CSR ID:1361257
                    data.F_ENAME  = box.get("F_ENAME"+idx) ;   // ����CSR ID:1361257
                    data.F_REGNO  = box.get("F_REGNO"+idx) ;   // �ֹε�Ϲ�ȣCSR ID:1361257             
                    //data.GUBUN         = box.get("GUBUN"+idx)     ;   // ����
                    //data.GUBUN = 	box.get("GUBUN"+idx).equals("X")?"9":"2";   // ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    GUBUN = box.get("GUBUN"+idx);
                    //ȸ�������� 1,  eHR��û 2, ����ûPDF 9
                    if ( GUBUN.equals("X")|| GUBUN.equals("9")){
                        data.GUBUN = 	"9";   
                    }else{
                        if ( box.get("GUBUN_SAP"+idx).equals("1")|| GUBUN.equals("1")){
                        	data.GUBUN = 	"1";     
                        }else{
                        	data.GUBUN = 	"2";   
                        }
                    }
                    data.DONA_YYMM     = box.get("DONA_YYMM"+idx) ;   // ��ο���
                    data.DONA_DESC     = box.get("DONA_DESC"+idx) ;   // ��αݳ���
                    data.DONA_NUMB     = box.get("DONA_NUMB"+idx) ;   // ����ڵ�Ϲ�ȣ
                    data.DONA_COMP     = box.get("DONA_COMP"+idx) ;   // ��ȣ
                    data.CHNTS         = box.get("CHNTS"+idx)     ;   // @v1.2����û��������
                    data.DONA_SEQN     = box.get("DONA_SEQN"+idx);    // ��α� �Ϸù�ȣ
                    data.DONA_AMNT     = box.get("DONA_AMNT"+idx) ;   // �ݾ�
                    data.DONA_DEDPR     = box.get("DONA_DEDPR"+idx) ;   // @2011 ������� ������ �ݾ� 
                    data.DONA_CRVYR  = box.get("DONA_CRVYR"+idx);   //@2011  �̿����� ����
                    data.DONA_CRVIN  = box.get("DONA_CRVIN"+idx);   //@2011  �̿�����üũ 
                    data.OMIT_FLAG = box.get("OMIT_FLAG"+idx)   ;   // ���������������
                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount );
                req.setAttribute( "gibuCarried_vt"  , gibuCarried_vt  );//[CSR ID:3569665]

                if ( curr_job.equals("build") ) {    // �Է�ȭ��
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuBuild.jsp";
                } else {                             // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuChange.jsp";
                }

            } else if(jobid.equals("first_print")) {
                String print_page_name = WebUtil.ServletURL + "hris.D.D11TaxAdjust.D11TaxAdjustGibuSV?jobid=print&targetYear="+targetYear+"&PERNR="+PERNR;
                req.setAttribute( "print_page_name", print_page_name );
                dest =  WebUtil.JspURL + "common/printFrame2.jsp";

            } else if( jobid.equals("print") ){
                gibuData_vt = rfc.getGibu( PERNR, targetYear );

                for( int i = 0 ; i < gibuData_vt.size() ; i++ ) {
                    D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibuData_vt.get(i);

                    data.DONA_AMNT = Double.toString(Double.parseDouble(data.DONA_AMNT)*100 );
                    data.DONA_DEDPR = Double.toString(Double.parseDouble(data.DONA_DEDPR)*100 ); // @2011 ������� ������ �ݾ� 

                    gibu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "gibu_vt"   , gibu_vt    );
                req.setAttribute( "PNT_SEQ", print_seq);////@2014 �������� �ҵ�����Ű� seq �߰�
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGibuPrint.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            req.setAttribute("PersonData",phonenumdata);
            req.setAttribute("PERNR",PERNR);
            Logger.debug.println(this, " destributed = " + dest);
            //ApLog ����
            if(jobid.equals("first")||jobid.equals("build")||jobid.equals("change_first")||jobid.equals("change")){
            	ApLoggerWriter.writeApLog("��������", "��α�", "D11TaxAdjustGibuSV", "��α�", ctrl, cnt, val, user, req.getRemoteAddr());
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
