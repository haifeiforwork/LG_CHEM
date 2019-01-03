/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �߰��Է�                                           */
/*   Program Name : �������� �߰��Է�                                           */
/*   Program ID   : A12FamilyBuild01SV                                          */
/*   Description  : �������� ��û�� ��ȸ�� �� �ֵ��� �ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  �赵��                                          */
/*   Update       : 2005-02-21  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.*;

public class A12FamilyBuild01SV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String subty = "";
            String objps = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            String screen = box.get("SCREEN");
            
            Vector  a12FamilyListData_vt = new Vector();
   
            if( jobid.equals("") ){
                jobid = "first";
            }
            if( screen.equals("") ){
            	screen = "A12";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            

           
            
            /******************************
             * 
             * @$ ���������� marco257
             * �븮��û ����üũ �߰�
             * user.e_representative;
             * 
             ******************************/
            //�븮��û ������ �ִ� ��� �߰�
            PERNR = WebUtil.nvl(box.get("PERNR"));
            String reSabunCk = user.e_representative;
            if (PERNR.equals("") || !reSabunCk.equals("Y")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("PhoneNumData2" , phonenumdata );

            if( jobid.equals("first") ) {              // ����ó�� ��ȸ ȭ�鿡 ���°��.
              
                a12FamilyListData_vt = (new A12FamilyListRFC()).getFamilyList(PERNR, subty, objps);
                
                Logger.debug.println(this, a12FamilyListData_vt.toString());

                req.setAttribute("SCREEN" , screen );
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                dest = WebUtil.JspURL+"A/A12Family/A12FamilyBuild01.jsp";
                            
            } else if( jobid.equals("del_first") ) {    // �������� ����Ʈȭ�鿡�� ������ư Ŭ��..
              
                a12FamilyListData_vt = (new A12FamilyListRFC()).getFamilyList(PERNR, subty, objps);
                
                Logger.debug.println(this, "������ ������ : " + a12FamilyListData_vt.toString());
                
                req.setAttribute("a12FamilyListData_vt", a12FamilyListData_vt);
                dest = WebUtil.JspURL+"A/A12Family/A12FamilyDelete.jsp";
                            
            } else if( jobid.equals("delete") ) {   

                A12FamilyListRFC   rfc                  = new A12FamilyListRFC();
                A12FamilyListData  a12FamilyListData    = new A12FamilyListData();
                                
                // �ּ� �Է�
                box.copyToEntity(a12FamilyListData);
                a12FamilyListData.PERNR  = PERNR;                                     // ���
                a12FamilyListData.REGNO  = DataUtil.removeSeparate(box.get("REGNO"));   // �ֹε�Ϲ�ȣ

                a12FamilyListData_vt.addElement(a12FamilyListData);
                
                Logger.debug.println(this, "�������� ���� ������ : " + a12FamilyListData_vt.toString());

                // ���� RFC Call
                rfc.delete(PERNR, subty, objps, a12FamilyListData_vt);

                String msg = "msg003";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A04FamilyDetailSV?PERNR="+PERNR+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
                
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
	}

}