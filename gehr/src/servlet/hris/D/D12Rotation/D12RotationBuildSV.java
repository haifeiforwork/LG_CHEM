package  servlet.hris.D.D12Rotation;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.D.D12Rotation.D12RotationBuild2Data;
import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.D12ZHRA003TData;
import hris.D.D12Rotation.D12ZHRA112TData;
import hris.D.D12Rotation.rfc.D12DayOffReqRFC;
import hris.D.D12Rotation.rfc.D12RotationBuildRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.NumberGetNextRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * D12RotationBuildSV.java
 * 부서월간근태결재 신청 Class
 *
 * @author 김종서
 * @version 1.0, 2009/02/24
 * @version 1.0, 2013/12/03 메일발송오류수정 CSR ID:9992
 */

public class D12RotationBuildSV extends ApprovalBaseServlet {
	private static String UPMU_TYPE ="36";   // 결재 업무타입(근태)
    private static String UPMU_NAME = "부서근태";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest    = "";

            final Box box = WebUtil.getBox(req);

            String t_year = box.get("t_year");
            String t_month = box.get("t_month");

            String i_from = box.get("S_DATE");
            String i_to = box.get("E_DATE");
            String i_orgeh = box.get("hdn_deptId");
            String i_orgeh_nm = box.get("hdn_deptNm");
            String i_pernr = "";

            String i_gbn = box.get("I_GBN","ORGEH");
            String i_searchdata   = box.get("I_SEARCHDATA");
            String txt_searchNm = box.get("txt_searchNm");


            if(i_gbn.equals("ORGEH")){
            	i_orgeh = i_searchdata;
            }else if(i_gbn.equals("PERNR")){
            	i_pernr = i_searchdata;
            }

            if(txt_searchNm == null){
            	txt_searchNm = "";
            }

            if (i_pernr == null || i_pernr.equals("")) {
            	i_pernr = user.empNo;
            }

	        /*************************************************************
	         * @$ 웹보안진단 marco257
	         * 세션에 있는 e_timeadmin = Y 인 사번이 부서 근태 권한이 있음.
	         * user.e_authorization.equals("E") 에서 !user.e_timeadmin.equals("Y")로 수정
	         *
	         * @ sMenuCode 코드 추가
	         * 부서근태 권한이 있는 사번과 MSS권한이 있는 사번을 체크하기 위해 추가
	         * 1406 : 부서근태 권한이 있는 메뉴코드(e_timeadmin 으로 체크)
	         * 1184 : 부서인사정보에 -> 조직통계 -> 근태 -> 월간근태 집계표에 권한이 있는사번
	         * 추가: 메뉴 코드가 없을경우 근태 권한이 우선한다.
	         *  (e_timeadmin 으로 체크못함 )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);

        	if(!checkTimeAuthorization(req, res)) return;

            String jobid   = box.get("jobid","first");

            //기준일자가 없을경우 현재일자를 default로한다.
            if( t_year == null || t_year.equals("") ) {
            	t_year = DataUtil.getCurrentDate().substring(0, 4);
            }
            if( t_month == null || t_month.equals("") ) {
            	t_month = DataUtil.getCurrentDate().substring(4, 6);
            }
            String i_month = t_year+t_month;

            //조회기간이 없을경우 현재일자를 default로 한다
            if(i_from == null || i_from.equals("")){
            	i_from = DataUtil.getCurrentDate();
            }
            if(i_to == null || i_to.equals("")){
            	i_to = DataUtil.getCurrentDate();
            }

            if( i_orgeh == null || i_orgeh.equals("") ) {
            	i_orgeh = user.e_orgeh;
            }

            D12RotationBuildRFC     rfcRotataionBuild    = new D12RotationBuildRFC();

            Vector main_vt1 = new Vector();
            Vector main_vt2 = new Vector();
            Vector main_vt3 = new Vector();
            Vector ret = new Vector();

            final D12ZHRA112TData d12ZHRA112TData  = new D12ZHRA112TData();
        	Utils.setFieldValue(d12ZHRA112TData, "FROMDA", i_from) ;  //승인요청 시작일
        	Utils.setFieldValue(d12ZHRA112TData, "MANDT", user.clientNo) ;  //클라이언트
        	Utils.setFieldValue(d12ZHRA112TData, "ORGEH", i_orgeh) ;  //조직 단위
        	Utils.setFieldValue(d12ZHRA112TData, "TODA", i_to) ; //승인요청 종료일

            int rowcount = box.getInt("RowCount");


            if( jobid.equals("first") || jobid.equals("print")) {                 //제일처음 저장 화면에 들어온경우.
            	//대근가능한 조의 리스트를 읽어 전체 사원 리스트를 jsp로 전송한다.

                String PERNR = getPERNR(box, user); //신청대상자 사번

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
            		ret = rfcRotataionBuild.getDetailForOrgeh(i_month, i_orgeh);
            	}else if(i_gbn.equals("PERNR")){
            		ret = rfcRotataionBuild.getDetailForPernr(i_month, i_pernr);
            	}

                main_vt1 = (Vector)ret.get(0);
                main_vt2 = (Vector)ret.get(1);
                main_vt3 = (Vector)ret.get(2);
                String E_RETURN    = (String)ret.get(3);
                String E_MESSAGE = (String)ret.get(4);
                String E_STEXT = (String)ret.get(8);


                if ( !E_RETURN.equals("E") ) {

                	//최근검색기능위해 저장함
                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
                	SearchDeptNameRotDeptTimeRFC func = null;
        	        Vector DeptName_vt  = null;
                    Vector search_vt    = new Vector();

    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
    	        	DeptName_vt  	= new Vector();

    	            d12SearchData.SPERNR =  user.empNo  ;    //사원 번호
    	            d12SearchData.OBJID = i_orgeh  ;    //오브젝트 ID
    	            d12SearchData.STEXT =E_STEXT  ;    //오브젝트 이름
    	            d12SearchData.EPERNR = i_pernr  ;    //사원 번호
    	            d12SearchData.ENAME = ""  ;    //조직ID
    	            d12SearchData.OBJTXT = E_STEXT  ;     //사원 또는 지원자의 포맷된 이름
    	            search_vt.addElement(d12SearchData);
    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //권한 Set!!!
    	            //최근검색기능

                    Vector main_vt3_temp = new Vector();
                    for(int i=0; i<main_vt3.size(); i++){
                    	D12RotationBuild2Data dataStat = (D12RotationBuild2Data)main_vt3.get(i);
                    	dataStat.APPR_STAT_CHK = "true";
                    	for(int j=0; j<main_vt2.size(); j++){
                    		D12RotationBuildData dataResult = (D12RotationBuildData)main_vt2.get(j);
                    		if(dataResult.BEGDA.equals(dataStat.BEGDA)){
                    			if(dataStat.APPR_STAT.equals("A")&&!dataResult.APPR_STAT.equals("A")){
                    				dataStat.APPR_STAT_CHK = "false";
                		    	}
                    		}
                    	}
                    	main_vt3_temp.addElement(dataStat);
                    }
                    main_vt3 = main_vt3_temp;

	                req.setAttribute("jobid",            jobid);
	                req.setAttribute("hdn_deptId",   i_orgeh);
	                req.setAttribute("hdn_deptNm",   i_orgeh_nm);
	                req.setAttribute("txt_searchNm",   txt_searchNm);
	                req.setAttribute("E_STEXT",   E_STEXT);
	                req.setAttribute("t_year",        t_year);
	                req.setAttribute("t_month",        t_month);
	                req.setAttribute("main_vt1",       main_vt1);
	                req.setAttribute("main_vt2",       main_vt2);
	                req.setAttribute("main_vt3",       main_vt3);
	                req.setAttribute("rowCount"  ,   Integer.toString(main_vt1.size())   );
	                req.setAttribute("I_SEARCHDATA"  ,   i_searchdata   );

	                if(jobid.equals("first")){
	                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuild.jsp?I_SEARCHDATA="+i_searchdata;
	                }else{
	                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationBuild_print.jsp?I_SEARCHDATA="+i_searchdata;
	                }
                } else {
                    String msg = E_MESSAGE;
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D12Rotation.D12RotationBuildSV?hdn_deptId="+i_orgeh+"&hdn_deptNm="+i_orgeh_nm+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, D12ZHRA112TData.class, new RequestFunction<D12ZHRA112TData>() {
                    public String porcess(D12ZHRA112TData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	D12RotationBuildRFC d12RotationBuildRFC = new D12RotationBuildRFC();
                    	d12RotationBuildRFC.setRequestInput(user.empNo, UPMU_TYPE);

                    	inputData = d12ZHRA112TData;

                        String AINF_SEQN = d12RotationBuildRFC.build(inputData, box, req);
                        if(!d12RotationBuildRFC.getReturn().isSuccess()) {
                            throw new GeneralException(d12RotationBuildRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
