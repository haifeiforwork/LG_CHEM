/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ������� ����											*/
/*   Program Name	:   ������� ����(����)									*/
/*   Program ID		: D40RemeInfoEachSV.java							*/
/*   Description		: ������� ����(����)										*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40DailScheFrameData;
import hris.D.D40TmGroup.D40RemeInfoFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;
import hris.D.D40TmGroup.rfc.D40RemeInfoEachRFC;
import hris.D.D40TmGroup.rfc.D40RemeInfoLumpFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40RemeInfoEachSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"),"SEARCH");
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));


			if("SEARCH".equals(gubun)){		//��ȹ�ٹ����� ��ȸ ����

		    	I_ACTTY = "R";	//T:�ϰ��ʱ���ȸ, U:�ϰ����ε�, A:���ε��ļ����ݿ�, R:������ȸ, I:�����Է�

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//���±׷����� �����ϱ�
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40RemeInfoFrameData data = new D40RemeInfoFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//�������� �����ϱ�
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40RemeInfoFrameData data = new D40RemeInfoFrameData();
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
		    		D40RemeInfoFrameData data = new D40RemeInfoFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
//		    		I_BEGDA = DataUtil.getCurrentDate();
		    		I_BEGDA = "";
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
//		    		I_ENDDA = DataUtil.getCurrentDate();
		    		I_ENDDA = "";
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}

		    	Vector vec = (new D40RemeInfoEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

				String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//�ȳ�����
	            String E_BEGDA = (String)vec.get(3);			//��ȸ������
	            String E_ENDDA = (String)vec.get(4);			//��ȸ������
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//��ȹ�ٹ�
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//��ȸ�� ����
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//���»��� �ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT4 = (Vector)vec.get(8);	//���� �ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT5 = (Vector)vec.get(9);	//��Ÿ

	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("E_BEGDA", E_BEGDA);
	            req.setAttribute("E_ENDDA", E_ENDDA);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);

	            req.setAttribute("textChange", "Y");		//���ϱٹ����� �ȳ����� ��ü�Ѵ�.
	            req.setAttribute("viewSource", "true");

	            printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40RemeInfoEach.jsp");

		    }else if("SAVE".equals(gubun)){		//��ȹ�ٹ����� ��ȸ ����

		    	String EDIT[] = req.getParameterValues("EDIT");
		    	String PERNR[] = req.getParameterValues("PERNR");
		    	String ENAME[] = req.getParameterValues("ENAME");
		    	String WWKTM[] = req.getParameterValues("WWKTM");
		    	String ACTIO[] = req.getParameterValues("ACTIO");

		    	/*�������� */
		    	String OBEGDA[] = req.getParameterValues("OBEGDA");
		    	String OSEQNR[] = req.getParameterValues("OSEQNR");
		    	String OWTMCODE[] = req.getParameterValues("OWTMCODE");
		    	String OLGART[] = req.getParameterValues("OLGART");
		    	String OBETRG[] = req.getParameterValues("OBETRG");
		    	String OBEGUZ[] = req.getParameterValues("OBEGUZ");
		    	String OENDUZ[] = req.getParameterValues("OENDUZ");
		    	String OPBEG1[] = req.getParameterValues("OPBEG1");
		    	String OPEND1[] = req.getParameterValues("OPEND1");
		    	String OSTDAZ[] = req.getParameterValues("OSTDAZ");
		    	String OREASON[] = req.getParameterValues("OREASON");
		    	String ODETAIL[] = req.getParameterValues("ODETAIL");
		    	/*�������� end*/
		    	String BEGDA[] = req.getParameterValues("BEGDA");
		    	String WTMCODE[] = req.getParameterValues("WTMCODE");
		    	String LGART[] = req.getParameterValues("LGART");
		    	String BETRG[] = req.getParameterValues("BETRG");
		    	String BEGUZ[] = req.getParameterValues("BEGUZ");
		    	String ENDUZ[] = req.getParameterValues("ENDUZ");
		    	String PBEG1[] = req.getParameterValues("PBEG1");
		    	String PEND1[] = req.getParameterValues("PEND1");
		    	String STDAZ[] = req.getParameterValues("STDAZ");
		    	String REASON[] = req.getParameterValues("REASON");
		    	String REASON_YN[] = req.getParameterValues("REASON_YN");
		    	String DETAIL[] = req.getParameterValues("DETAIL");
		    	String DETAIL_YN[] = req.getParameterValues("DETAIL_YN");
		    	String TIME_YN[] = req.getParameterValues("TIME_YN");
		    	String STDAZ_YN[] = req.getParameterValues("STDAZ_YN");
		    	String PTIME_YN[] = req.getParameterValues("PTIME_YN");
		    	String TPROG[] = req.getParameterValues("TPROG");

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));
		    	String empNo = WebUtil.nvl(req.getParameter("I_PERNR"));
		    	String empNm = WebUtil.nvl(req.getParameter("I_ENAME"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
		    		I_BEGDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
		    		I_ENDDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}
		    	Vector OBJID = new Vector();
//		    	Vector OBJID2 = new Vector();

		    	//ȭ�� ������
		    	if(PERNR != null){
					for( int i = 0; i <  PERNR.length; i++ ){
						D40RemeInfoFrameData data = new D40RemeInfoFrameData();

						data.EDIT	= EDIT[i];
						data.PERNR	= PERNR[i];
						data.ENAME = ENAME[i];
						data.WWKTM = WWKTM[i];
						data.ACTIO = ACTIO[i];		//����Ÿ�Կ	- ���߰�INS /  ����� DEL

						/*��������*/
						data.OBEGDA	= OBEGDA[i].replace(".","");	//��������-������
						data.OWTMCODE	= OWTMCODE[i];				//��������-��������
						data.OLGART	= OLGART[i];						//��������-�ӱ�����
						data.OBETRG	= OBETRG[i];						// ��������-�ݾ�
						data.OSEQNR	= OSEQNR[i];						// ��������-����Ÿ��
						data.OBEGUZ	= OBEGUZ[i];						//��������-���۽ð�
						data.OENDUZ	= OENDUZ[i];						//��������-����ð�
						data.OPBEG1	= OPBEG1[i];						//��������-�޽Ľ��۽ð�
						data.OPEND1	= OPEND1[i];						//��������-�޽�����ð�
						data.OSTDAZ = OSTDAZ[i];						//��������-�ð� ��
						data.OREASON = OREASON[i];					//��������-�����ڵ�
						data.ODETAIL = ODETAIL[i];						//��������-�󼼻���
						/*�������� end*/

						data.BEGDA	= BEGDA[i].replace(".","");			//������
						data.WTMCODE	= WTMCODE[i];				//��������
						data.LGART	= LGART[i];								//�ӱ�����
						data.BETRG	= BETRG[i];								//�ݾ�
						data.BEGUZ	= BEGUZ[i].replace(":","");
						if(!"".equals(WebUtil.nvl(ENDUZ[i]))){
							if("00:00".equals(WebUtil.nvl(ENDUZ[i]))){
								data.ENDUZ = "2400";
							}else{
								data.ENDUZ = ENDUZ[i].replace(":","");
							}
						}else{
							data.ENDUZ = ENDUZ[i];
						}

						data.PBEG1	= PBEG1[i].replace(":","");
						if(!"".equals(WebUtil.nvl(PEND1[i]))){
							if("00:00".equals(WebUtil.nvl(PEND1[i]))){
								data.PEND1 = "2400";
							}else{
								data.PEND1 = PEND1[i].replace(":","");
							}
						}else{
							data.PEND1 = PEND1[i];
						}
						data.STDAZ = STDAZ[i];
						data.REASON = REASON[i];
						data.DETAIL = DETAIL[i];
						data.REASON_YN = REASON_YN[i];
						data.DETAIL_YN = DETAIL_YN[i];
						data.TIME_YN = TIME_YN[i];
						data.PTIME_YN = PTIME_YN[i];
						data.STDAZ_YN = STDAZ_YN[i];
						data.TPROG = TPROG[i];

						OBJID.addElement(data);
					}
		    	}
				D40RemeInfoEachRFC rfc = new D40RemeInfoEachRFC();
				I_ACTTY = "I";	//������ :  I �����Է�, U �ϰ����ε�, A ���ε��ļ����ݿ�
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID,  I_BEGDA, I_ENDDA);

				String E_RETURN    = (String)resultList.get(0);		//return message code
	            String E_MESSAGE = (String)resultList.get(1);		//return message
	            String E_INFO = (String)resultList.get(2);				//�ȳ�����
	            String E_BEGDA = (String)resultList.get(3);			//��ȸ������
	            String E_ENDDA = (String)resultList.get(4);			//��ȸ������
	            String E_SAVE_CNT = (String)resultList.get(5);		//����� �Ǽ� ī��Ʈ �ȳ�����
	            Vector OBJPS_OUT1 = (Vector)resultList.get(6);	//��ȹ�ٹ�
	            Vector OBJPS_OUT2 = (Vector)resultList.get(7);	//��ȸ�� ����
	            Vector OBJPS_OUT3 = (Vector)resultList.get(8);	//���»���
	            Vector OBJPS_OUT4 = (Vector)resultList.get(9);	//����
	            Vector OBJPS_OUT5 = (Vector)resultList.get(10);	//��Ÿ
	            Vector OBJPS_OUT6 = (Vector)resultList.get(11);	//[NTM] �� 50�ð� �ʰ���

	            req.setAttribute("E_RETURN", E_RETURN);
	            req.setAttribute("I_BEGDA", I_BEGDA);
	            req.setAttribute("I_ENDDA", I_ENDDA);
	            req.setAttribute("I_SCHKZ", I_SCHKZ);
	            req.setAttribute("I_PERNR", empNo);
	            req.setAttribute("I_ENAME", empNm);
	            req.setAttribute("gubun", gubun);

	            req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);	//��ȹ�ٹ�
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);	//��ȸ�� ����
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);	//���»���
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);	//����
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);	//��Ÿ
	            req.setAttribute("OBJPS_OUT6", OBJPS_OUT6);	//[NTM] �� 50�ð� �ʰ���
	            req.setAttribute("viewSource", "true");
//	            req.setAttribute("textChange", "Y");		//���ϱٹ����� �ȳ����� ��ü�Ѵ�.

		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40RemeInfoEach.jsp");

		    }else if("EXCEL".equals(gubun)){		//��ȹ�ٹ����� ��ȸ ����

		    	I_ACTTY = "R";	//T:�ϰ��ʱ���ȸ, U:�ϰ����ε�, A:���ε��ļ����ݿ�, R:������ȸ, I:�����Է�

		    	Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//���±׷����� �����ϱ�
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40RemeInfoFrameData data = new D40RemeInfoFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//�������� �����ϱ�
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40TmSchkzFrameData data = new D40TmSchkzFrameData();
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
		    		D40DailScheFrameData data = new D40DailScheFrameData();
					if(!"".equals(empNos[i])){
						data.PERNR = WebUtil.nvl(empNos[i]);
						data.ENAME = WebUtil.nvl(empNms[i]);
						T_IMPERS.addElement(data);
					}
				}

		    	String I_BEGDA = "";
		    	String I_ENDDA = "";
		    	String I_SCHKZ = WebUtil.nvl(req.getParameter("I_SCHKZ"));

		    	if("".equals(WebUtil.nvl(req.getParameter("I_BEGDA")))){
		    		I_BEGDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA")).replace(".","");
		    	}
		    	if("".equals(WebUtil.nvl(req.getParameter("I_ENDDA")))){
		    		I_ENDDA = DataUtil.getCurrentDate();
		    	}else{
		    		I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA")).replace(".","");
		    	}

//		    	Vector vec = (new D40DailScheEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);
		    	Vector vec = (new D40RemeInfoEachRFC()).getDailScheEach(user.empNo, I_ACTTY, I_BEGDA, I_ENDDA, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

		    	String E_RETURN    = (String)vec.get(0);		//return message code
	            String E_MESSAGE = (String)vec.get(1);		//return message
	            String E_INFO = (String)vec.get(2);				//�ȳ�����
	            String E_BEGDA = (String)vec.get(3);			//��ȸ������
	            String E_ENDDA = (String)vec.get(4);			//��ȸ������
	            Vector OBJPS_OUT1 = (Vector)vec.get(5);	//��ȹ�ٹ�
	            Vector OBJPS_OUT2 = (Vector)vec.get(6);	//��ȸ�� ����
	            Vector OBJPS_OUT3 = (Vector)vec.get(7);	//���»��� �ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT4 = (Vector)vec.get(8);	//���»��� �ڵ�-�ؽ�Ʈ

//	            req.setAttribute("I_DATUM", WebUtil.nvl(req.getParameter("I_DATUM")));
//	            req.setAttribute("I_SCHKZ", I_SCHKZ);
//	            req.setAttribute("I_PERNR", empNo);
//	            req.setAttribute("I_ENAME", empNm);

//	            req.setAttribute("E_INFO", E_INFO);
//	            req.setAttribute("E_BEGDA", E_BEGDA);
//	            req.setAttribute("E_ENDDA", E_ENDDA);
//	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT2", OBJPS_OUT2);
//	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
//	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("viewSource", "true");
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40RemeInfoEachExcel.jsp");

		    }else if("SEARCHONE".equals(gubun)){

		    	I_ACTTY = "P";	//P:���߰� �� �Է��ʵ� ���涧���� ����

		    	String searchPERNR = WebUtil.nvl(req.getParameter("searchPERNR"));
				String searchBEGDA = WebUtil.nvl(req.getParameter("searchBEGDA"));
				String searchWTMCODE = WebUtil.nvl(req.getParameter("searchWTMCODE"));
				String no = WebUtil.nvl(req.getParameter("no"));

		    	Vector T_IMLIST = new Vector();
	    		D40RemeInfoFrameData data = new D40RemeInfoFrameData();

				if(!"".equals(searchPERNR)){
					data.PERNR = searchPERNR;
				}
				if(!"".equals(searchBEGDA)){
					data.BEGDA = searchBEGDA.replace(".","");
				}
				if(!"".equals(searchWTMCODE)){
					data.WTMCODE = searchWTMCODE;
				}
				T_IMLIST.addElement(data);

		    	Vector vec = (new D40RemeInfoLumpFrameRFC()).getOverTimeOne(user.empNo, I_ACTTY, T_IMLIST);

		    	Vector OBJPS_OUT1 = (Vector)vec.get(2);	//��ȸ�� ����
		    	String E_RETURN = (String)vec.get(3);	//RETURN

		    	req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
		    	req.setAttribute("E_RETURN", E_RETURN);
		    	req.setAttribute("no", no);
		    	req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40RemeInfoHidden.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
