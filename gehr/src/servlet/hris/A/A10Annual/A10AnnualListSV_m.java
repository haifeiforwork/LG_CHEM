package	servlet.hris.A.A10Annual;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A10Annual.A10AnnualData;
import hris.A.A10Annual.rfc.A10AnnualAgreementRFC;
import hris.A.A10Annual.rfc.A10AnnualRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A10AnnualListSV_m.java
 * ��������� ��ȸ �ϰ� ������༭�� ���� �ֵ��� �ϴ� Class
 *(�ӿ� �����θ� ���� �뵵 ����)
 * @author �ڿ���
 * @version 1.0, 2002/01/10
 *                    : 2016-03-09      [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
 *                    : 2017-04-07      eunha [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��
 *                    : 2018-03-09	   cykim [CSR ID:3628833] ������༭ ��ȸ ��� ���� ��û�� ��
 *                      2018-05-25  rdcamel //[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
 */
public class A10AnnualListSV_m extends EHRBaseServlet {

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

            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") || page == null ) {
                jobid = "page";
            }

            if( page.equals("") || page == null ){ //������ ����
                page = "1";
            }
//          @����༺ �߰�
			if(!checkAuthorization(req, res)) return ;

            if ( user_m != null ) {

	            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : "+user_m.toString()+"  servlet Page : " + page);

	            if( jobid.equals("page") ){
	            	//[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
	               //Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//���, ���糯¥
	            	Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualListLong( user_m.empNo );
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
	                dest = WebUtil.JspURL+"A/A10Annual/A10AnnualList_m.jsp";
	//                    }
	              //  }
	            } else if( jobid.equals("search") ) { //�ش翬�� ����Ÿ���� �޴´�.
	                String ZYEAR = box.get("ZYEAR");
	                //temp
	                //ZYEAR = "2014";
	                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	                dest = WebUtil.JspURL+"common/printFrame.jsp";
	                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );

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

	                if( (user_m.companyCode).equals("C100") ){ //test��
	                    //@v1.0 ��������û 07.06.21 �⵵�� �����༭�� �̷°����� �ϱ�� ��
	                    if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007 ) {
	                    	// [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
	                    	if(user_m.e_persk.equals("11")||user_m.e_persk.equals("12")){
	                    		//2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(URL��������) start
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp&type=M";
	                    		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp?type=M";
	                    		//2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(URL��������) end
	                            imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
	                    	}else{//�ӿ� ���� ��༭ �����θ� ���. �繫�� �ŵ� ������ �̰� �ٲ�� ��.
	                    		//2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(URL��������) start
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp&type=M";
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";

	                    		//[CSR ID:3628833] ������༭ ��ȸ ��� ���� ��û�� �� start
	                    		dest = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/A10AnnualDetail.jsp?type=M";
		                        imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                    		//[CSR ID:3628833] ������༭ ��ȸ ��� ���� ��û�� �� end

	                    		//2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(URL��������) end
		                        //imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                    		//req.setAttribute("msg", "�ӿ� ������༭ ��ȸ ����� �ƴմϴ�.");
	                    		//dest = WebUtil.JspURL+"common/caution.jsp";
	                    		//printJspPage(req, res, dest);
	                    	}
	                    } else {
	                        dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail.jsp";
	                        imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
	                    }
	                }/* else {
	                    if( (a10AnnualData.ZYEAR).equals("2001") ) {
	                        char compChar = (a10AnnualData.TRFGR).charAt(0);
	                        Logger.debug.println( this, "���ޱ��� ù���� : "+compChar );
	                        if( compChar == '��' || compChar == '��' ){//LG���� ���ޱ��а�.....
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail02.jsp";//����
	                        } else {
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail.jsp";//���
	                        }
	//                  2004�� ������༭�� ��� 2004�� ����ȸ ����Ʈ�� ��ȸ�Ѵ�.
	                    } else if( (a10AnnualData.ZYEAR).equals("2004") ) {
	                        Vector A10AnnualDetail_vt = ( new A10AnnualRFC() ).getAnnualDetail( user.empNo );//���, ���糯¥

	                        req.setAttribute( "A10AnnualDetail_vt", A10AnnualDetail_vt );

	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail04.jsp";
	                    } else {
	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail.jsp";
	                    }
	                    imgURL = WebUtil.JspURL+"A/A10Annual/N100/";
	                }*/

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

	                ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( user_m.empNo ,"2",ZYEAR,user_m.companyCode );

	                String AGRE_FLAG = (String)ret.get(0);
	                String E_BETRG = (String)ret.get(1);
	                String msg = "";

	                if(AGRE_FLAG.equals("Y")){
		                msg = "������� ���ǰ� �Ϸ�Ǿ����ϴ�.";
	                }else{
	                	msg = "ó�� �����Դϴ�.";
	                }

	                req.setAttribute("msg", msg);


	                //@v1.0 ��������û 07.06.21 �⵵�� �����༭�� �̷°����� �ϱ�� ��
	                if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007  ) {
	                	if(user_m.e_persk.equals("11")||user_m.e_persk.equals("12")){
	                		// [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
	                		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp?type=M";
	                        imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
	                	}else{
		                    //dest = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/A10AnnualDetail.jsp";
		                    //imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                		req.setAttribute("msg", "�ӿ� ������༭ ��ȸ ����� �ƴմϴ�.");
	                		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";
                    		printJspPage(req, res, dest);
	                	}
	                }// else {
	                  //  dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail.jsp";
	                  //  imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
	               // }

	            }
            }else{
	           	 req.setAttribute( "a10AnnualData", null );
	           	 dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";
	             imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/";
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