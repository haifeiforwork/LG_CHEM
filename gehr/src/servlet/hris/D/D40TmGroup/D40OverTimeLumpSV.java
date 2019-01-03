/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태													*/
/*   2Depth Name		:  초과근무													*/
/*   Program Name	:  초과근무(일괄)											*/
/*   Program ID		:  D40OverTimeLumpSV.java							*/
/*   Description		:  초과근무(일괄)											*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  정준현                                          	*/
/*   Update				:  2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.rfc.D40OverTimeLumpFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40OverTimeLumpSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));

			String I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA"));
			String I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA"));

			if("EXCEL".equals(gubun)){
				Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40OverTimeFrameData data = new D40OverTimeFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//조직도로 선택하기
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40OverTimeFrameData data = new D40OverTimeFrameData();
							data.OBJID = WebUtil.nvl(deptNos[i]);
							OBJID.addElement(data);
						}
					}
				}
				Vector vec = (new D40OverTimeLumpFrameRFC()).getOverTimeLumpExcelDown(user.empNo, I_ACTTY, I_SELTAB, OBJID );
				req.setAttribute("viewSource", "true");
				req.setAttribute("excelSheet1", vec.get(0));
				req.setAttribute("excelSheet2", vec.get(1));
				req.setAttribute("T_YN_DATA", vec.get(2));
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeExcelDown.jsp");

		    }else if("SAVE".equals(gubun)){

//		    	String PERNR[] = req.getParameterValues("PERNR");
//		    	String ENAME[] = req.getParameterValues("ENAME");
//		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String TPROG[] = req.getParameterValues("TPROG");

		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String ENDDA[] = req.getParameterValues("ENDDA");
		    	String BEGUZ[] = req.getParameterValues("BEGUZ");
		    	String ENDUZ[] = req.getParameterValues("ENDUZ");
		    	String PBEG1[] = req.getParameterValues("PBEG1");
		    	String PEND1[] = req.getParameterValues("PEND1");
		    	String PBEG2[] = req.getParameterValues("PBEG2");
		    	String PEND2[] = req.getParameterValues("PEND2");
		    	String VTKEN[] = req.getParameterValues("VTKEN");
		    	String REASON[] = req.getParameterValues("REASON");
		    	String DETAIL[] = req.getParameterValues("DETAIL");
		    	String EDIT[] = req.getParameterValues("EDIT");

		    	Vector OBJID = new Vector();
				for( int i = 0; i <  PERNR.length; i++ ){
//					if("X".equals(WebUtil.nvl(EDIT[i]))){
						D40OverTimeFrameData excelDt = new D40OverTimeFrameData();
						excelDt.EDIT = EDIT[i];
						excelDt.PERNR = PERNR[i];
						excelDt.ENAME = ENAME[i];
						excelDt.BEGDA = BEGDA[i].replace(".","");
						excelDt.ENDDA = ENDDA[i].replace(".","");

						if(!"".equals(WebUtil.nvl(BEGUZ[i]))){
							String sBEGUZ = BEGUZ[i].substring(0,2);
							if("24".equals(sBEGUZ)){
								sBEGUZ = "00";
							}
							String eBEGUZ = BEGUZ[i].substring(3,5);
							excelDt.BEGUZ	= sBEGUZ+eBEGUZ;
						}else{
							excelDt.BEGUZ	= BEGUZ[i];
						}
						if(!"".equals(WebUtil.nvl(ENDUZ[i]))){
							if("00:00".equals(WebUtil.nvl(ENDUZ[i]))){
								excelDt.ENDUZ = "2400";
							}else{
								excelDt.ENDUZ	= ENDUZ[i].replace(":","");
							}
						}else{
							excelDt.ENDUZ	= ENDUZ[i];
						}

						if(!"".equals(WebUtil.nvl(PBEG1[i]))){
							String sPBEG1 = PBEG1[i].substring(0,2);
							if("24".equals(sPBEG1)){
								sPBEG1 = "00";
							}
							String ePBEG1 = PBEG1[i].substring(3,5);
							excelDt.PBEG1	= sPBEG1+ePBEG1;
						}else{
							excelDt.PBEG1	= PBEG1[i];
						}
						if(!"".equals(WebUtil.nvl(PEND1[i]))){
							if("00:00".equals(WebUtil.nvl(PEND1[i]))){
								excelDt.PEND1 = "2400";
							}else{
								excelDt.PEND1	= PEND1[i].replace(":","");
							}
						}else{
							excelDt.PEND1	= PEND1[i];
						}

						if(!"".equals(WebUtil.nvl(PBEG2[i]))){
							String sPBEG2 = PBEG2[i].substring(0,2);
							if("24".equals(sPBEG2)){
								sPBEG2 = "00";
							}
							String ePBEG2 = PBEG2[i].substring(3,5);
							excelDt.PBEG2	= sPBEG2+ePBEG2;
						}else{
							excelDt.PBEG2	= PBEG2[i];
						}
						if(!"".equals(WebUtil.nvl(PEND2[i]))){
							if("00:00".equals(WebUtil.nvl(PEND2[i]))){
								excelDt.PEND2 = "2400";
							}else{
								excelDt.PEND2	= PEND2[i].replace(":","");
							}
						}else{
							excelDt.PEND2	= PEND2[i];
						}

	//					excelDt.BEGUZ = BEGUZ[i].replace(":","");
	//					excelDt.ENDUZ = ENDUZ[i].replace(":","");
	//					excelDt.PBEG1 = PBEG1[i].replace(":","");
	//					excelDt.PEND1 = PEND1[i].replace(":","");
	//					excelDt.PBEG2 = PBEG2[i].replace(":","");
	//					excelDt.PEND2 = PEND2[i].replace(":","");
						excelDt.VTKEN = VTKEN[i];
						excelDt.REASON = REASON[i];
						excelDt.DETAIL = DETAIL[i];
						excelDt.TPROG = TPROG[i];

						OBJID.addElement(excelDt);
//					}
				}

				D40OverTimeLumpFrameRFC rfc = new D40OverTimeLumpFrameRFC();
				I_ACTTY = "A";	//실행모드 : U 일괄업로드, A 업로드후수정반영
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID);

				String E_RETURN = (String)resultList.get(0);	//리턴코드
				String E_MESSAGE = (String)resultList.get(1);	//리턴메세지
				String E_SAVE_CNT = (String)resultList.get(2);	//처리내용
				Vector T_REASON = (Vector)resultList.get(3);	//근태사유
				Vector T_EXLIST = (Vector)resultList.get(4);	//목록
				Vector OBJPS_OUT5 = (Vector)resultList.get(5);	//기타


				req.setAttribute("E_RETURN", E_RETURN);
				req.setAttribute("E_MESSAGE", E_MESSAGE);
				req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);
				req.setAttribute("OBJPS_OUT3", T_REASON);
				req.setAttribute("OBJPS_OUT1", T_EXLIST);
				req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);
				req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeLumpExcel.jsp");

		    }else{

		    	String I_DATUM = "";
				String I_SCHKZ = "";
				Vector T_IMPERS = new Vector();
				Vector OBJID = new Vector();

				Vector vec = (new D40OverTimeLumpFrameRFC()).getOverTimeLump(user.empNo, I_ACTTY, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

		    	String E_RETURN 		= (String)vec.get(0);	//리턴코드
		    	String E_MESSAGE 	= (String)vec.get(1);	//리턴메세지
	            String E_BEGDA 		= (String)vec.get(2);	//조회시작일
	            String E_ENDDA 		= (String)vec.get(3);	//조회종료일
	            String E_SAVE_CNT 	= (String)vec.get(4);	//저장시 건수 카운트 안내문구
	            String E_INFO 			= (String)vec.get(5);	//안내문구
	            Vector OBJPS_OUT1 = (Vector)vec.get(6);	//조회된정보
	            Vector OBJPS_OUT2 = (Vector)vec.get(7);	//계획근무	코드-텍스트
	            Vector OBJPS_OUT3 = (Vector)vec.get(8);	//근태사유	코드-텍스트
	            Vector OBJPS_OUT4 = (Vector)vec.get(9);	//근태사유	코드-텍스트
	            Vector OBJPS_OUT5 = (Vector)vec.get(10);	//사유 기타

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);

	            req.setAttribute("textChange", "Y");		//안내문구 교체한다.
	            req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OverTimeLumpExcel.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
