/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근무계획표 조회 										*/
/*   Program Name	:   근무계획표 조회 										*/
/*   Program ID		: D40TmSchkzPlanningChartSV.java					*/
/*   Description		: 근무계획표 조회											*/
/*   Note				: 																*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.D40TmSchkzPlanningChartNoteData;
import hris.D.D40TmGroup.rfc.D40TmSchkzPlanningChartRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40TmSchkzPlanningChartSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);

			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));

			//상단 공통 조회
			Vector OBJID = new Vector();
			if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
				if("PRINT".equals(gubun)){
					String[] iSeqnos = ISEQNO.split("-");
					for(int i=0; i<iSeqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40TmSchkzFrameData data = new D40TmSchkzFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}

			}else{		//조직도로 선택하기
				String[] deptNos = searchDeptNo.split(",");
				for(int i=0; i<deptNos.length; i++){
					D40TmSchkzFrameData data = new D40TmSchkzFrameData();
					if(deptNos[i] != null && !"".equals(deptNos[i])){
				    	data.OBJID = WebUtil.nvl(deptNos[i]);
				      	OBJID.addElement(data);
					}
				}
			}

			String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
	    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

	    	Vector T_IMPERS = new Vector();
	    	String[] empNos = empNo.split(",");
	    	String[] empNms = empNm.split(",");
	    	for(int i=0; i<empNos.length; i++){
				D40TmSchkzFrameData data = new D40TmSchkzFrameData();
				if(!"".equals(empNos[i])){
					data.PERNR = WebUtil.nvl(empNos[i]);
					data.ENAME = WebUtil.nvl(empNms[i]);
					T_IMPERS.addElement(data);
				}
			}
	    	String I_DATUM = "";
	    	if(req.getParameter("I_DATUM") == null){
	    		I_DATUM = "";
	    	}else{
	    		I_DATUM = WebUtil.nvl(req.getParameter("I_DATUM")).replace(".","");
	    	}
	    	String I_ENDDA = "";
	    	if(req.getParameter("I_ENDDA") == null){
//	    		Calendar cal = Calendar.getInstance();
//	    		cal.add(Calendar.MONTH, +1);
//	    		cal.add(Calendar.DATE, -1);
//	    		Date currentTime=cal.getTime();
//	    		SimpleDateFormat formatter=new SimpleDateFormat("yyyyMMdd");
//	    		I_ENDDA = formatter.format(currentTime);;
	    		I_ENDDA = "";
	    	}else{
	    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
	    	}

	    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

	    	if("SAVE".equals(gubun)){

	    		int titleCnt = Integer.parseInt(  WebUtil.nvl(req.getParameter("titleCnt"),"0"));	//조회된 리스트 개수

	    		String PERNR[] = req.getParameterValues("PERNR");
	    		String ENAME[] = req.getParameterValues("ENAME");
	    		String T1[] = req.getParameterValues("T1");
	    		String T2[] = req.getParameterValues("T2");
	    		String T3[] = req.getParameterValues("T3");
	    		String T4[] = req.getParameterValues("T4");
	    		String T5[] = req.getParameterValues("T5");
	    		String T6[] = req.getParameterValues("T6");
	    		String T7[] = req.getParameterValues("T7");
	    		String T8[] = req.getParameterValues("T8");
	    		String T9[] = req.getParameterValues("T9");
	    		String T10[] = req.getParameterValues("T10");
	    		String T11[] = req.getParameterValues("T11");
	    		String T12[] = req.getParameterValues("T12");
	    		String T13[] = req.getParameterValues("T13");
	    		String T14[] = req.getParameterValues("T14");
	    		String T15[] = req.getParameterValues("T15");
	    		String T16[] = req.getParameterValues("T16");
	    		String T17[] = req.getParameterValues("T17");
	    		String T18[] = req.getParameterValues("T18");
	    		String T19[] = req.getParameterValues("T19");
	    		String T20[] = req.getParameterValues("T20");
	    		String T21[] = req.getParameterValues("T21");
	    		String T22[] = req.getParameterValues("T22");
	    		String T23[] = req.getParameterValues("T23");
	    		String T24[] = req.getParameterValues("T24");
	    		String T25[] = req.getParameterValues("T25");
	    		String T26[] = req.getParameterValues("T26");
	    		String T27[] = req.getParameterValues("T27");
	    		String T28[] = req.getParameterValues("T28");
	    		String T29[] = req.getParameterValues("T29");
	    		String T30[] = req.getParameterValues("T30");
	    		String T31[] = req.getParameterValues("T31");

	    		String D1[] = req.getParameterValues("D1");
	    		String D2[] = req.getParameterValues("D2");
	    		String D3[] = req.getParameterValues("D3");
	    		String D4[] = req.getParameterValues("D4");
	    		String D5[] = req.getParameterValues("D5");
	    		String D6[] = req.getParameterValues("D6");
	    		String D7[] = req.getParameterValues("D7");
	    		String D8[] = req.getParameterValues("D8");
	    		String D9[] = req.getParameterValues("D9");
	    		String D10[] = req.getParameterValues("D10");
	    		String D11[] = req.getParameterValues("D11");
	    		String D12[] = req.getParameterValues("D12");
	    		String D13[] = req.getParameterValues("D13");
	    		String D14[] = req.getParameterValues("D14");
	    		String D15[] = req.getParameterValues("D15");
	    		String D16[] = req.getParameterValues("D16");
	    		String D17[] = req.getParameterValues("D17");
	    		String D18[] = req.getParameterValues("D18");
	    		String D19[] = req.getParameterValues("D19");
	    		String D20[] = req.getParameterValues("D20");
	    		String D21[] = req.getParameterValues("D21");
	    		String D22[] = req.getParameterValues("D22");
	    		String D23[] = req.getParameterValues("D23");
	    		String D24[] = req.getParameterValues("D24");
	    		String D25[] = req.getParameterValues("D25");
	    		String D26[] = req.getParameterValues("D26");
	    		String D27[] = req.getParameterValues("D27");
	    		String D28[] = req.getParameterValues("D28");
	    		String D29[] = req.getParameterValues("D29");
	    		String D30[] = req.getParameterValues("D30");
	    		String D31[] = req.getParameterValues("D31");

	    		String I1[] = req.getParameterValues("I1");
	    		String I2[] = req.getParameterValues("I2");
	    		String I3[] = req.getParameterValues("I3");
	    		String I4[] = req.getParameterValues("I4");
	    		String I5[] = req.getParameterValues("I5");
	    		String I6[] = req.getParameterValues("I6");
	    		String I7[] = req.getParameterValues("I7");
	    		String I8[] = req.getParameterValues("I8");
	    		String I9[] = req.getParameterValues("I9");
	    		String I10[] = req.getParameterValues("I10");
	    		String I11[] = req.getParameterValues("I11");
	    		String I12[] = req.getParameterValues("I12");
	    		String I13[] = req.getParameterValues("I13");
	    		String I14[] = req.getParameterValues("I14");
	    		String I15[] = req.getParameterValues("I15");
	    		String I16[] = req.getParameterValues("I16");
	    		String I17[] = req.getParameterValues("I17");
	    		String I18[] = req.getParameterValues("I18");
	    		String I19[] = req.getParameterValues("I19");
	    		String I20[] = req.getParameterValues("I20");
	    		String I21[] = req.getParameterValues("I21");
	    		String I22[] = req.getParameterValues("I22");
	    		String I23[] = req.getParameterValues("I23");
	    		String I24[] = req.getParameterValues("I24");
	    		String I25[] = req.getParameterValues("I25");
	    		String I26[] = req.getParameterValues("I26");
	    		String I27[] = req.getParameterValues("I27");
	    		String I28[] = req.getParameterValues("I28");
	    		String I29[] = req.getParameterValues("I29");
	    		String I30[] = req.getParameterValues("I30");
	    		String I31[] = req.getParameterValues("I31");

	    		Vector OBJID2 = new Vector();
				for( int i = 0; i <  titleCnt; i++ ){
					D40TmSchkzPlanningChartNoteData dt = new D40TmSchkzPlanningChartNoteData();

					if(PERNR != null){
						dt.PERNR = PERNR[i];

						if(ENAME != null){
							dt.ENAME = ENAME[i];
						}
						if(D1 != null){
							dt.T1 = T1[i];
							dt.D1 = D1[i];
							dt.I1 = I1[i];
						}
						if(D2 != null){
							dt.T2 = T2[i];
							dt.D2 = D2[i];
							dt.I2 = I2[i];
						}
						if(D3 != null){
							dt.T3 = T3[i];
							dt.D3 = D3[i];
							dt.I3 = I3[i];
						}
						if(D4 != null){
							dt.T4 = T4[i];
							dt.D4 = D4[i];
							dt.I4 = I4[i];
						}
						if(D5 != null){
							dt.T5 = T5[i];
							dt.D5 = D5[i];
							dt.I5 = I5[i];
						}
						if(D6 != null){
							dt.T6 = T6[i];
							dt.D6 = D6[i];
							dt.I6 = I6[i];
						}
						if(D7 != null){
							dt.T7 = T7[i];
							dt.D7 = D7[i];
							dt.I7 = I7[i];
						}
						if(D8 != null){
							dt.T8 = T8[i];
							dt.D8 = D8[i];
							dt.I8 = I8[i];
						}
						if(D9 != null){
							dt.T9 = T9[i];
							dt.D9 = D9[i];
							dt.I9 = I9[i];
						}
						if(D10 != null){
							dt.T10 = T10[i];
							dt.D10 = D10[i];
							dt.I10 = I10[i];
						}
						if(D11 != null){
							dt.T11 = T11[i];
							dt.D11 = D11[i];
							dt.I11 = I11[i];
						}
						if(D12 != null){
							dt.T12 = T12[i];
							dt.D12 = D12[i];
							dt.I12 = I12[i];
						}
						if(D13 != null){
							dt.T13 = T13[i];
							dt.D13 = D13[i];
							dt.I13 = I13[i];
						}
						if(D14 != null){
							dt.T14 = T14[i];
							dt.D14 = D14[i];
							dt.I14 = I14[i];
						}
						if(D15 != null){
							dt.T15 = T15[i];
							dt.D15 = D15[i];
							dt.I15 = I15[i];
						}
						if(D16 != null){
							dt.T16 = T16[i];
							dt.D16 = D16[i];
							dt.I16 = I16[i];
						}
						if(D17 != null){
							dt.T17 = T17[i];
							dt.D17 = D17[i];
							dt.I17 = I17[i];
						}
						if(D18 != null){
							dt.T18 = T18[i];
							dt.D18 = D18[i];
							dt.I18 = I18[i];
						}
						if(D19 != null){
							dt.T19 = T19[i];
							dt.D19 = D19[i];
							dt.I19 = I19[i];
						}
						if(D20 != null){
							dt.T20 = T20[i];
							dt.D20 = D20[i];
							dt.I20 = I20[i];
						}
						if(D21 != null){
							dt.T21 = T21[i];
							dt.D21 = D21[i];
							dt.I21 = I21[i];
						}
						if(D22 != null){
							dt.T22 = T22[i];
							dt.D22 = D22[i];
							dt.I22 = I22[i];
						}
						if(D23 != null){
							dt.T23 = T23[i];
							dt.D23 = D23[i];
							dt.I23 = I23[i];
						}
						if(D24 != null){
							dt.T24 = T24[i];
							dt.D24 = D24[i];
							dt.I24 = I24[i];
						}
						if(D25 != null){
							dt.T25 = T25[i];
							dt.D25 = D25[i];
							dt.I25 = I25[i];
						}
						if(D26 != null){
							dt.T26 = T26[i];
							dt.D26 = D26[i];
							dt.I26 = I26[i];
						}
						if(D27 != null){
							dt.T27 = T27[i];
							dt.D27 = D27[i];
							dt.I27 = I27[i];
						}
						if(D28 != null){
							dt.T28 = T28[i];
							dt.D28 = D28[i];
							dt.I28 = I28[i];
						}
						if(D29 != null){
							dt.T29 = T29[i];
							dt.D29 = D29[i];
							dt.I29 = I29[i];
						}
						if(D30 != null){
							dt.T30 = T30[i];
							dt.D30 = D30[i];
							dt.I30 = I30[i];
						}
						if(D31 != null){
							dt.T31 = T31[i];
							dt.D31 = D31[i];
							dt.I31 = I31[i];
						}
					}
					OBJID2.addElement(dt);
				}

				Vector vec = (new D40TmSchkzPlanningChartRFC()).savePlanningChart(user.empNo, I_ACTTY, OBJID2, I_DATUM, I_ENDDA);

				String E_INFO = (String)vec.get(0);	//안내문구
		    	String E_RETURN    = (String)vec.get(1);
	            String E_MESSAGE = (String)vec.get(2);
	            Vector T_SCHKZ = (Vector)vec.get(3);		//계획근무
	            Vector T_TPROG = (Vector)vec.get(4);		//일일근무상세설명
	            Vector T_EXPORTA = (Vector)vec.get(5);	 //근무계획표-TITLE
	            Vector T_EXPORTB = (Vector)vec.get(6);	 //근무계획표-DATA
	            Vector T_EXERR = (Vector)vec.get(7);	 //오류내역
	            String E_BEGDA = (String)vec.get(8);	 //리턴 조회시작일
	            String E_ENDDA = (String)vec.get(9);	 //리턴 조회종료일

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_RETURN", E_RETURN);
	            req.setAttribute("E_MESSAGE", E_MESSAGE);
	            req.setAttribute("T_SCHKZ", T_SCHKZ);
	            req.setAttribute("T_TPROG", T_TPROG);
	            req.setAttribute("T_EXPORTA", T_EXPORTA);
	            req.setAttribute("T_EXPORTB", T_EXPORTB);
	            req.setAttribute("T_EXERR", T_EXERR);

	            req.setAttribute("I_DATUM", I_DATUM);	//검색 조회시작일
	            req.setAttribute("I_ENDDA", I_ENDDA);		//검색 조회시작일
	            req.setAttribute("E_BEGDA", E_BEGDA);	//리턴 조회시작일
	            req.setAttribute("E_ENDDA", E_ENDDA);	//리턴 조회종료일
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);
	            req.setAttribute("gubun", gubun);

	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChart.jsp");

	    	}else{

	    		Vector vec = (new D40TmSchkzPlanningChartRFC()).getPlanningChart(user.empNo, I_SELTAB, OBJID, I_DATUM, I_ENDDA, I_SCHKZ, T_IMPERS);
		    	String E_INFO = (String)vec.get(0);	//안내문구
		    	String E_RETURN    = (String)vec.get(1);
	            String E_MESSAGE = (String)vec.get(2);
	            Vector T_SCHKZ = (Vector)vec.get(3);		//계획근무
	            Vector T_TPROG = (Vector)vec.get(4);		//일일근무상세설명
	            Vector T_EXPORTA = (Vector)vec.get(5);	 //근무계획표-TITLE
	            Vector T_EXPORTB = (Vector)vec.get(6);	 //근무계획표-DATA
	            String E_BEGDA = (String)vec.get(7);	 //리턴 조회시작일
	            String E_ENDDA = (String)vec.get(8);	 //리턴 조회종료일

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_RETURN", E_RETURN);
	            req.setAttribute("E_MESSAGE", E_MESSAGE);
	            req.setAttribute("T_SCHKZ", T_SCHKZ);
	            req.setAttribute("T_TPROG", T_TPROG);
	            req.setAttribute("T_EXPORTA", T_EXPORTA);
	            req.setAttribute("T_EXPORTB", T_EXPORTB);

	            req.setAttribute("I_DATUM", I_DATUM);	//검색 조회시작일
	            req.setAttribute("I_ENDDA", I_ENDDA);		//검색 조회시작일
	            req.setAttribute("E_BEGDA", E_BEGDA);	//리턴 조회시작일
	            req.setAttribute("E_ENDDA", E_ENDDA);	//리턴 조회종료일
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);

	            if("EXCEL".equals(gubun)){
	            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartExcel.jsp");
	            }else if("PRINT".equals(gubun)){
	            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartPrint.jsp");
	            }else if("PDF".equals(gubun)){
	            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChartPdf.jsp");
	            }else{
	            	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40TmSchkzPlanningChart.jsp");
	            }

	    	}



		} catch (Exception e) {

//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
