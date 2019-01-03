package servlet.hris.A.A20TempAddress;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.rfc.A13AddressListRFC;
import hris.A.A20TempAddress.A20TempAddressListData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.util.Vector;

/**
 * A20TempAddressBuildSV.java
 * �� �Ҽ� �ֵ��� �ϴ� Class
 *
 * @author �赵��   
 * @version 1.0, 2001/12/26
 */
public class A20TempAddressBuildSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        boolean isCommit = false;
        Connection conn = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String subty = "";
            
            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            Vector A20TempAddressListData_vt = new Vector();
            
            if( jobid.equals("first") ) {           //����ó�� �Է�ȭ�鿡 ���°��.
                A20TempAddressListData_vt = (new A13AddressListRFC()).getAddressList(box);
                
                Logger.debug.println(this, A20TempAddressListData_vt.toString());
                    
                req.setAttribute("A20TempAddressListData_vt", A20TempAddressListData_vt);
                
                dest = WebUtil.JspURL+"A/A20TempAddress/A20TempAddressBuild.jsp";
            } else if( jobid.equals("create") ) {   //�Է�ȭ�鿡�� �����ư�� �������.
                A13AddressListRFC   rfc                   = new A13AddressListRFC();
                A20TempAddressListData  A20TempAddressListData    = new A20TempAddressListData();

                // �ּ� �Է�
                A20TempAddressListData.PSTLZ     = box.get("PSTLZ")    ;   // �����ȣ           
                A20TempAddressListData.STRAS     = box.get("STRAS")    ;   // �ּ�               
                A20TempAddressListData.LOCAT     = box.get("LOCAT")    ;   // �ι�° �ּ�        
                A20TempAddressListData.TELNR     = box.get("TELNR")    ;   // ��ȭ��ȣ           
                
                A20TempAddressListData_vt.addElement(A20TempAddressListData);
                
                Logger.debug.println(this, A20TempAddressListData_vt.toString());
                                 //  ------------------- �ڵ�����
                // ��û RFC Call
               // vcAuthProgramCode = new Vector();
               // if (userGroup != null && !userGroup.equals("")) {
               //     for (int i = 0; i < rowNum; i++) {
              //          AuthProgramCode authProgramCode = new AuthProgramCode();
             //           box.copyToEntity(authProgramCode ,i);
            //            Logger.debug.println(this ,"I[" + i + "] =" + authProgramCode.authKind);
             //           vcAuthProgramCode.add(authProgramCode);
           //         } // end for
            //        mcdb.saveAuthProgramCode(vcAuthProgramCode ,userGroup);
           //     } // end if
                               // ---------------------------
                subty = box.get("SUBTY");
                
                rfc.build(box, A20TempAddressListData_vt );

                String msg = "msg001";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A20TempAddress.A20TempAddressListSV';";
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
            //DBUtil.close(con);
        }
	}
}