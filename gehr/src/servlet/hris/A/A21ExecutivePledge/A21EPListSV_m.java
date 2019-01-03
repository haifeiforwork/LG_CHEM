package	servlet.hris.A.A21ExecutivePledge;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.A.A10Annual.*;
import hris.A.A10Annual.rfc.*;

/**
 * A21EPListSV_m.java
 * �ӿ����� ���༭�� ��ȸ �ϰ� �ӿ����� ���༭�� ���� �ֵ��� �ϴ� Class
 *
 * @author ������
 * @version 1.0, 2016-03-09      [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û  
 */
public class A21EPListSV_m extends EHRBaseServlet_m {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);

            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String dest   = "";
            String jobid  = "";    // 2���� �� pageó���� page, ����ȸ�� - search
            String page   = "";    //paging ó��
            String imgURL = "";    //image��� ����
            
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") || page == null ) {
                jobid = "page";
            }
            
            if( page.equals("") || page == null ){ //������ ����
                page = "1";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : "+user_m.toString()+"  servlet Page : " + page);

            if( jobid.equals("page") ){
                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//���, ���糯¥
//                    if ( A10AnnualData_vt.size() == 0 ) {
//                        Logger.debug.println(this, "Data Not Found");
//                        String msg = "msg004";
//                        //String url = "history.back();";
//                        req.setAttribute("msg", msg);
//                        //req.setAttribute("url", url);
//                        dest = WebUtil.JspURL+"common/caution.jsp";
//                    } else {
                req.setAttribute( "page", page );
                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
                dest = WebUtil.JspURL+"A/A20AnnualBoard/A21ExecutivesPledge.jsp?type=M";
//                    }
              //  }
            } else if( jobid.equals("search") ) { //�ش翬�� ����Ÿ���� �޴´�.
                String ZYEAR = box.get("ZYEAR");
                //temp
                //ZYEAR = "2014";
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV_m?jobid=print&ZYEAR="+ZYEAR );
                dest = WebUtil.JspURL+"common/printFrame.jsp";
                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV_m?jobid=print&ZYEAR="+ZYEAR );

            } else if( jobid.equals("print") ) {
                String ZYEAR = box.get("ZYEAR");
                A10AnnualData a10AnnualData = new A10AnnualData();

                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//���, ���糯¥
                for( int i = A10AnnualData_vt.size()-1; i >=0 ; i-- ){
                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
                    if( ZYEAR.equals( data.ZYEAR ) ){
                        a10AnnualData = data;
                    }
                }
                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
                req.setAttribute( "a10AnnualData", a10AnnualData );
                req.setAttribute( "ZYEAR", ZYEAR );
                Logger.debug.println(this, "a10AnnualData::"+ a10AnnualData.toString() );
                

            	if(user_m.e_persk.equals("11")||user_m.e_persk.equals("12")){
            		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A21ExecutivesPledge.jsp?type=M";
                    imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
            	}
                
                
            }
            else if( jobid.equals("agree") ) { //@v1.0 07.06.21���� ��ư Ŭ����
                String ZYEAR = box.get("I_YEAR");
                
                A10AnnualData a10AnnualData = new A10AnnualData();

                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//���, ���糯¥
                for( int i = A10AnnualData_vt.size()-1; i >=0 ; i-- ){
                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
                    if( ZYEAR.equals( data.ZYEAR ) ){
                        a10AnnualData = data;
                    }
                }
                req.setAttribute( "a10AnnualData", a10AnnualData );
                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
                req.setAttribute( "ZYEAR", ZYEAR );
                
                //��������
                Vector              ret            = new Vector();
                
                ret = ( new A10AnnualOathAgreementRFC() ).getAnnualAgreeYn( user_m.empNo ,"2",ZYEAR,user_m.companyCode );   
                
                String AGRE_FLAG = (String)ret.get(0); 
                String E_BETRG = (String)ret.get(1); 
                String msg = "";
                
                if(AGRE_FLAG.equals("Y")){
	                msg = "�����ӿ����༭ ���ǰ� �Ϸ�Ǿ����ϴ�.";
                }else{
                	msg = "ó�� �����Դϴ�.";
                }

                req.setAttribute("msg", msg);
                
                //@v1.0 ��������û 07.06.21 �⵵�� �����༭�� �̷°����� �ϱ�� ��
                if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007  ) {
                    dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A21ExecutivesPledge.jsp?type=M";
                    imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
                } else {
                    dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A21ExecutivesPledge.jsp?type=M";
                    imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/";
                }
               
            }            
            
            req.setAttribute( "imgURL", imgURL );
            Logger.debug.println( this, " destributed = " + dest );
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}