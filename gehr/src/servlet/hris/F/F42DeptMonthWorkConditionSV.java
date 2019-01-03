/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ���� ���� ����ǥ                                            */
/*   Program ID   : F42DeptMonthWorkConditionSV                                 */
/*   Description  : �μ��� ���� ���� ����ǥ ��ȸ�� ���� ����                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-17 �����                                           */
/*   Update       :  @PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel                                                           */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import com.common.RFCReturnEntity;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F42DeptMonthWorkConditionRFC;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F42DeptMonthWorkConditionSV
 * �μ��� ���� ��ü �μ����� ���� ���� ����ǥ ������ ��������
 * F42DeptMonthWorkConditionRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F42DeptMonthWorkConditionSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
            String year   = WebUtil.nvl(req.getParameter("year1"));
            String month  = WebUtil.nvl(req.getParameter("month1"));
            String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����
            String yymmdd   = "";
            String yyyymm   = ""; //Global���� ���
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
            String dest_deail = user.area.toString();
	        String E_BUKRS = WebUtil.nvl(req.getParameter("E_BUKRS"));  //erup�������
	        Area area = null;
            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
            if (!user.sapType.isLocal()){
            	if(year.equals("")||month.equals("")){
    				yyyymm = DataUtil.getCurrentDate().toString().substring(0,6);
    			} else {
    				yyyymm = year + month;
    			}

		    	BukrsCodeByOrgehRFCEurp rfc = new BukrsCodeByOrgehRFCEurp();
		    	Vector vt = rfc.getBukrsCode(deptId);
		        E_BUKRS = (String)vt.get(1);

	        	if ( E_BUKRS.equals("G290")) {
	        		dest_deail ="PL";
	        		area = Area.PL ;

	        	} else if ( E_BUKRS.equals("G260")) {
	        		dest_deail = "DE";
	        		area = Area.DE ;

	        	} else if (E_BUKRS.equals("G340") || E_BUKRS.equals("G400"))  {
	        		dest_deail = "US";
	        		area = Area.US ;
	        	
	        	} else if (E_BUKRS.equals("G560")) {//@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel
	        		dest_deail = "US";
	        		area = Area.MX ;

	        	} else {
	        		dest_deail = "CN";
	        		area = Area.CN ;
	 	        }



            }else{
            	area = Area.KR ;
            	if(year.equals("")||month.equals("")){
            		yymmdd = DataUtil.getCurrentDate();
            	} else {
            		yymmdd = year + month + "20";
            	}

                Box box = new Box("orgBox");
                box.put("I_ORGEH", deptId);
               	box.put("I_PERNR", user.empNo);
               	box.put("I_AUTHOR", "M");
               	box.put("I_GUBUN", "");

            }
	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;
	        String E_YYYYMON 	= "";


	        /*************************************************************
	         * @$ ���������� marco257
	         * ���ǿ� �ִ� e_timeadmin = Y �� ����� �μ� ���� ������ ����.
	         * user.e_authorization.equals("E") ���� !user.e_timeadmin.equals("Y")�� ����
	         *
	         * @ sMenuCode �ڵ� �߰�
	         * �μ����� ������ �ִ� ����� MSS������ �ִ� ����� üũ�ϱ� ���� �߰�
	         * 1406 : �μ����� ������ �ִ� �޴��ڵ�(e_timeadmin ���� üũ)
	         * 1184 : �μ��λ������� -> ������� -> ���� -> �������� ����ǥ�� ������ �ִ»��
	         * �߰�: �޴� �ڵ尡 ������� ���� ������ �켱�Ѵ�.
	         *  (e_timeadmin ���� üũ���� )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //�����λ����� > ��û > �μ�����
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //�μ��λ�����
//	    	 @����༺ �߰�
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }

            /*************************************************************
	         * @$ ���������� marco257
	         *
	         * �ش� ����� ������ ��ȸ�Ҽ� �ִ��� üũ
	         * üũ���� ���� - SM ��û����
	         *
	         **************************************************************/
//           	String sfunctionName = "ZHRA_RFC_CHECK_BELONG3";
//           	EHRComCRUDInterfaceRFC sRFC = new EHRComCRUDInterfaceRFC();
//	    	   String reCode = sRFC.setImportInsert(box, sfunctionName, "RETURN");

	    	//if(reCode.equals("S")){ //��ȸ ����


		        F42DeptMonthWorkConditionRFC func    = null;
		        Vector F42DeptMonthWorkCondition_vt  = null;
		        Vector F42DeptMonthWorkConditionTotal  = null;

				if ( !deptId.equals("") ) {
		        	func       				= new F42DeptMonthWorkConditionRFC();
		        	F42DeptMonthWorkCondition_vt  	= new Vector();
		            Vector ret 				= func.getDeptMonthWorkCondition(deptId, yymmdd,yyyymm, "1", checkYN,user.sapType,area);	// ���� '1' set!

		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);

		            if (!user.sapType.isLocal()){
			            F42DeptMonthWorkCondition_vt 	= (Vector)ret.get(2);
			            F42DeptMonthWorkConditionTotal  = (Vector)ret.get(3);
			            E_YYYYMON = yyyymm;
		            }else{
		            	E_YYYYMON  				= (String)ret.get(2);
		            	F42DeptMonthWorkCondition_vt 	= (Vector)ret.get(3);
					}
				}
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        RFCReturnEntity result = func.getReturn();
		        //RFC ȣ�� ������.
		      //  if( result.isSuccess()){
		        	req.setAttribute("E_BUKRS", E_BUKRS);
			        req.setAttribute("checkYn", checkYN);
		        	req.setAttribute("E_YYYYMON", E_YYYYMON);
		        	req.setAttribute("subView", subView);
		        	Logger.debug.println(this, " subView = " + subView);
			        req.setAttribute("F42DeptMonthWorkCondition_vt", F42DeptMonthWorkCondition_vt);
			        req.setAttribute("F42DeptMonthWorkConditionTotal", F42DeptMonthWorkConditionTotal);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F42DeptMonthWorkConditionExcel_"+ dest_deail +".jsp";
			        else if( excelDown.equals("print") ) //����� ���.
			        	dest = WebUtil.JspURL+"F/F42DeptMonthWorkConditionPrint_"+ dest_deail +".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F42DeptMonthWorkCondition_"+ dest_deail +".jsp";
			        Logger.debug.println(this, "E_RETURN : "+ E_RETURN);
			        Logger.debug.println(this, "E_MESSAGE : "+ E_MESSAGE);
			        Logger.debug.println(this, "F42DeptMonthWorkCondition_vt : "+ F42DeptMonthWorkCondition_vt.toString());
			        Logger.debug.println(this, "F42DeptMonthWorkConditionTotal : "+F42DeptMonthWorkConditionTotal);
			    //RFC ȣ�� ���н�.
		        //}else{
			    //    String msg = E_MESSAGE;
	            //    String url = "history.back();";
			        //String url = "location.href = '"+WebUtil.JspURL+"F/F42DeptMonthWorkCondition.jsp?checkYn="+checkYN+"';";
			     //   req.setAttribute("msg", msg);
			     //   req.setAttribute("url", url);
			     //   dest = WebUtil.JspURL+"common/msg.jsp";
		        //}
	    	//}else{
	    		//String msg = "�λ����� ��ȸ������ �����ϴ�";
               // String url = "history.back();";
               //req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                //dest = WebUtil.JspURL+"common/msg.jsp";
	    	//}
	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}