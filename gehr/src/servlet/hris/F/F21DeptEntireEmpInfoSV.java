/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �����
*   Program ID   : F21DeptEntireEmpInfoSV.java
*   Description  : �μ��� ����θ� �˻�
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import hris.F.rfc.F21DeptEntireEmpInfoRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F21DeptEntireEmpInfoSV
 * �μ��� ���� ��ü �μ����� ����������� ��������
 * F21DeptEntireEmpInfoRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 * update 2017-07-07 [CSR ID:3428660] �λ� list ȭ�� ���� ����
 */
public class F21DeptEntireEmpInfoSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            Box box = WebUtil.getBox( req ) ;
            //String checkYN   = box.get("checkYN");  //�μ��ڵ�
            String checkYN   = box.get("chck_yeno");  //�μ��ڵ�[CSR ID:3428660] �λ� list ȭ�� ���� ����
            checkYN          = WebUtil.nvl(checkYN, "N");      //�����μ�����.
            String deptId    = box.get("hdn_deptId");  //�μ��ڵ�
            String deptNm    = box.get("hdn_deptNm");  //�μ���
            String hdn_count = box.get("hdn_count");  //�μ���
	        WebUserData user = WebUtil.getSessionUser(req);	                               //����
	        boolean userArea = user.area.toString().equals("KR");
            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
                deptId = user.e_objid;
            }

            String page   = box.get( "page" ) ;
            if( page.equals("")  ){
                page = "1";
            }

            String dest         = "";
	        boolean RfcSuccess  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ*/
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

	            Vector DeptEntireEmpInfo_vt  = new Vector();
	            F21DeptEntireEmpInfoRFC f21Rfc = null;

	            if ( !deptId.equals("") ) {
	            	f21Rfc       = new F21DeptEntireEmpInfoRFC();
	                Vector ret = f21Rfc.getDeptEntireEmpList(deptId, checkYN, userArea);

	            	RfcSuccess = f21Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f21Rfc.getReturn().MSGTX;
	            	DeptEntireEmpInfo_vt = (Vector) ret.get(0);
	            }

	            //RFC ȣ�� ������.
	            if( RfcSuccess ){
	                req.setAttribute( "page", page );
	                req.setAttribute( "hdn_deptId", deptId );
	                req.setAttribute( "hdn_deptNm", deptNm );
	                req.setAttribute( "hdn_count",  hdn_count );

	                req.setAttribute("checkYn", checkYN);
	                req.setAttribute("DeptEntireEmpInfo_vt", DeptEntireEmpInfo_vt);
	                req.setAttribute("pageType", "M");

	                dest = WebUtil.JspURL+"F/F21DeptEntireEmpInfo.jsp";
	            //RFC ȣ�� ���н�.
	            }else{
		        	throw new GeneralException(E_MESSAGE);
	            }
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}