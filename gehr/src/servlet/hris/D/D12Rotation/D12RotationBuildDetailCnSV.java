package  servlet.hris.D.D12Rotation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D12Rotation.D12RotationBuildCnData;
import hris.D.D12Rotation.rfc.D12RotationBuildDetailCnRFC;
import hris.D.D13ScheduleChange.D13ScheduleChangeData;
import hris.common.WebUserData;
import hris.sys.SysAuthInput;
import hris.sys.rfc.SysAuthRFC;

/**
 * D12RotationBuildDetailCnSV.java
 * 초과근무조회(남경PI)class
 * @author
 * @version 1.0
 */

public class D12RotationBuildDetailCnSV extends EHRBaseServlet {


    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String i_txt_pernr = box.get("txt_pernr", ""); //사번필터


            String deptId = WebUtil.nvl(req.getParameter("hdn_deptId"), user.e_objid); 				// 부서코드
    		String excelDown   = WebUtil.nvl(req.getParameter("hdn_excel"));  			// excelDown
    		String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N");		// 하위부서여부

    		req.setAttribute("txt_pernr", i_txt_pernr);
    		
    		
            if (jobid.equals("first") || jobid.equals("search")) {   //제일처음 신청 화면에 들어온경우.

                D12RotationBuildDetailCnRFC d12Rfc = new D12RotationBuildDetailCnRFC();
        		String i_begda =WebUtil.nvl(req.getParameter("I_BEGDA"), DataUtil.getAfterDate(DataUtil.getCurrentDate(), -1));
        		String i_endda =WebUtil.nvl(req.getParameter("I_ENDDA"), DataUtil.getCurrentDate());
                Vector <D12RotationBuildCnData> D12RotationBuildDetailData_vt = d12Rfc.getDetail(deptId, checkYN, i_begda, i_endda);

                if( d12Rfc.getReturn().isSuccess() ){
                	

                	/** 사번으로 필터링 */
                	if(!i_txt_pernr.equals("")){
                		
	    				for( int i =  D12RotationBuildDetailData_vt.size() -1;i >= 0; i-- ){
	    					D12RotationBuildCnData data  = (D12RotationBuildCnData)D12RotationBuildDetailData_vt.get(i);
	    					if( !data.getPERNR().equals(i_txt_pernr) ){
	    						D12RotationBuildDetailData_vt.remove(data);
	    					}
	    				}
                	}
                	
                	req.setAttribute("D12RotationBuildDetailData_vt", D12RotationBuildDetailData_vt);
                	req.setAttribute("I_BEGDA",  box.getString("I_BEGDA"));
                	req.setAttribute("I_ENDDA", box.getString("I_ENDDA"));
                	req.setAttribute("checkYn",  WebUtil.nvl(req.getParameter("chck_yeno"), "N"));
                }
		        if( excelDown.equals("ED") ) //엑셀저장일 경우.
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuildDetailExcel_CN.jsp";
		        else
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuildDetail_CN.jsp";
                printJspPage(req, res, dest);

                
                
            } else if (jobid.equals("save")) {
            	dest = WebUtil.JspURL + "D/D12Rotation/D12RotationBuildDetail_CN.jsp";

				Vector<D12RotationBuildCnData> RotationBuildData_vt =  box.getVector(D12RotationBuildCnData.class, "LIST_");

				Vector<D12RotationBuildCnData> saveList = new Vector<D12RotationBuildCnData>();

				for( int i = 0; i < RotationBuildData_vt.size(); i++ ){
					if(    (RotationBuildData_vt.get(i).getZCHECK().equals("X") &&	RotationBuildData_vt.get(i).getBEGDA().equals(""))   ||
						   (RotationBuildData_vt.get(i).getZCHECK().equals("X") &&	!RotationBuildData_vt.get(i).getBEGDA().equals(""))   ){
						saveList.add(RotationBuildData_vt.get(i));
					}else if (RotationBuildData_vt.get(i).getZCHECK().equals("") &&	!deleteBEGDACheck( RotationBuildData_vt.get(i).getBEGDA()))  {
						RotationBuildData_vt.get(i).setCBEGDA(RotationBuildData_vt.get(i).getBEGDA());
						RotationBuildData_vt.get(i).setCENDDA(RotationBuildData_vt.get(i).getENDDA());
						RotationBuildData_vt.get(i).setPERNR(RotationBuildData_vt.get(i).getCPERNR());
						RotationBuildData_vt.get(i).setENAME(RotationBuildData_vt.get(i).getCENAME());
						RotationBuildData_vt.get(i).setBEGUZ(RotationBuildData_vt.get(i).getCBEGUZ());
						RotationBuildData_vt.get(i).setENDUZ(RotationBuildData_vt.get(i).getCENDUZ());
						RotationBuildData_vt.get(i).setPBEG1(RotationBuildData_vt.get(i).getCPBEG1());
						RotationBuildData_vt.get(i).setPEND1(RotationBuildData_vt.get(i).getCPEND1());
						RotationBuildData_vt.get(i).setPBEG2(RotationBuildData_vt.get(i).getCPBEG2());
						RotationBuildData_vt.get(i).setPEND2(RotationBuildData_vt.get(i).getCPEND2());
						RotationBuildData_vt.get(i).setREASON(RotationBuildData_vt.get(i).getCREASON());
						saveList.add(RotationBuildData_vt.get(i));
					}
				}
                /* 실제 신청 부분 */
				int totalSize = 0;
				for( int i = 0; i < saveList.size(); i++ ){
					if( saveList.get(i).getZCHECK().equals("X") ){
						totalSize ++;
					}
				}
        		D12RotationBuildDetailCnRFC d12Rfc = new D12RotationBuildDetailCnRFC();

        		Vector <D12RotationBuildCnData> D12RotationBuildDetailData_vt = d12Rfc.setRotationBuild(user.empNo, deptId, checkYN, saveList);
        		int failSize = 0;
				for( int i = 0; i < D12RotationBuildDetailData_vt.size(); i++ ){
					if( !D12RotationBuildDetailData_vt.get(i).getZMSG().equals("") ){
						failSize ++;
					}
				}
        		req.setAttribute("D12RotationBuildDetailData_vt", D12RotationBuildDetailData_vt);
            	req.setAttribute("I_BEGDA",  box.getString("I_BEGDA"));
            	req.setAttribute("I_ENDDA", box.getString("I_ENDDA"));
            	req.setAttribute("checkYn",  checkYN);
            	req.setAttribute("saveAfter", "Y");
            	req.setAttribute("failSize", failSize);
            	req.setAttribute("totalSize", totalSize);

        		printJspPage(req, res, dest);
            } else if (jobid.equals("deleteRow")) {
            	dest = WebUtil.JspURL + "D/D12Rotation/D12RotationBuildDetail_CN.jsp";

				Vector<D12RotationBuildCnData> RotationBuildData_vt =  box.getVector(D12RotationBuildCnData.class, "LIST_");

				Vector<D12RotationBuildCnData> deleteList = new Vector<D12RotationBuildCnData>();

				for( int i = 0; i < RotationBuildData_vt.size(); i++ ){
					if(    (RotationBuildData_vt.get(i).getZCHECK().equals("X") &&	!deleteBEGDACheck( RotationBuildData_vt.get(i).getBEGDA()))
						|| (RotationBuildData_vt.get(i).getZCHECK().equals("") )){
						deleteList.add(RotationBuildData_vt.get(i));
					}
				}

				D12RotationBuildDetailCnRFC d12Rfc = new D12RotationBuildDetailCnRFC();
				Vector <D12RotationBuildCnData> D12RotationBuildDetailData_vt = d12Rfc.delete(deptId, checkYN, deleteList);
        		req.setAttribute("D12RotationBuildDetailData_vt", D12RotationBuildDetailData_vt);
            	req.setAttribute("I_BEGDA",  box.getString("I_BEGDA"));
            	req.setAttribute("I_ENDDA", box.getString("I_ENDDA"));
            	req.setAttribute("checkYn",  checkYN);

        		printJspPage(req, res, dest);
        	}else if (jobid.equals("check")) {

				D01OTCheckGlobalRFC rfc = new D01OTCheckGlobalRFC();

				//-------- 근태기간완료된것을 신청하는  check (li hui)----------------------
				String upmu_type = "01";	//---초과근무 업무타입
 				String flag = rfc.check1(user.empNo, box.getString("I_BEGDA"),upmu_type);

				String msg = flag;
				res.getWriter().print(msg);
				return;
            } else if (jobid.equals("searchPerson")) {
                SysAuthInput inputData = new SysAuthInput();
                inputData.I_CHKGB = "2";
                inputData.I_DEPT = user.empNo;
                inputData.I_PERNR = box.get("PERNR");

                SysAuthRFC sysAuthRFC = new SysAuthRFC();
                if (sysAuthRFC.isAuth(inputData)) {
            		res.getWriter().print("S");
            	}else{
            		res.getWriter().print("E");
            	}
            	return;
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
        } catch (Exception e) {
            Logger.error(e);

            throw new GeneralException(e);
        }
    }
    private boolean deleteBEGDACheck(String begda){
    	boolean returnCheck = false;
    	if( begda.equals("") || begda == null || begda.equals("0000-00-00")){
    		returnCheck = true;
    	}
    	return returnCheck;
    }
}

