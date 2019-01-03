/******************************************************************************/
/*		System Name	: g-HR
/*   	1Depth Name 	: 공통
/*   	2Depth Name 	: 공통
/*   	Program Name	: 결재정보
/*   	Program ID   	: AppUtilEurp.java
/*   	Description  	: 결재항목에 관한 프로세스를 실행하는 Class [유럽용]
/*   	Note         		:
/*   	Creation     	: 2010-07-13 yji
/*   	Update       	: 2010-11-11 juning	@v1.0 [USA] APPR_TYPE에 따른 결재자 변경 getAppVector2() 추가
/******************************************************************************/

package hris.common.util;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.util.Vector;

import com.common.Global;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.common.AppLineData;
import hris.common.AppLineKeyGlobal;
import hris.common.PersonData;
import hris.common.rfc.ApprInfoRFC;
import hris.common.rfc.DecisionerRFC;
import hris.common.rfc.PersonInfoRFC;

public class AppUtilEurp {

	private final static String APPR_TYPE = "01";

	private final static String UPMU_FLAG = "A";

	public static boolean mailFlag = false;

	/**
	 * 결재신청
	 *
	 * @param empNo
	 *            java.lang.String 사원번호
	 * @param upmuType
	 *            java.lang.String 업무형태
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	protected static Global g = Utils.getBean("global");
	public static Vector getAppVector(String empNo, String upmuType) throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal = new AppLineKeyGlobal();
			AppLineKeyGlobal.I_APPR_TYPE	= APPR_TYPE;
			AppLineKeyGlobal.I_DATUM 		= DataUtil.getCurrentDate();	// 현재일자.
			AppLineKeyGlobal.I_PERNR 		= empNo;
			AppLineKeyGlobal.I_UPMU_FLAG	= UPMU_FLAG;
			AppLineKeyGlobal.I_UPMU_TYPE	= upmuType;

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisioner(AppLineKeyGlobal);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	public static Vector getAppVector(String empNo, String upmuType, String work_date, String hours)
		throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal = new AppLineKeyGlobal();
			AppLineKeyGlobal.I_APPR_TYPE	= APPR_TYPE;
			AppLineKeyGlobal.I_DATUM 		= work_date;	// 현재일자.
			AppLineKeyGlobal.I_PERNR 		= empNo;
			AppLineKeyGlobal.I_UPMU_FLAG	= UPMU_FLAG;
			AppLineKeyGlobal.I_UPMU_TYPE	= upmuType;
			AppLineKeyGlobal.I_ANZHL 		= hours;

			Logger.debug.println("#####	APPR_TYPE	:	" + APPR_TYPE);
			Logger.debug.println("#####	I_DATE		:	" + work_date);
			Logger.debug.println("#####	I_PERNR		:	" + empNo);
			Logger.debug.println("#####	UPMU_FLAG	:	" + UPMU_FLAG);
			Logger.debug.println("#####	UPMU_TYPE	:	" + upmuType);
			Logger.debug.println("#####	ANZHL		:	" + hours);

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisionerExt(AppLineKeyGlobal);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	public static Vector getAppVector1(String empNo, String upmuType, String E_ABRTG, String AWART)
		throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal	= new AppLineKeyGlobal();
			AppLineKeyGlobal.I_APPR_TYPE	= APPR_TYPE;
			AppLineKeyGlobal.I_DATUM		= DataUtil.getCurrentDate(); // 현재일자.
			AppLineKeyGlobal.I_PERNR		= empNo;
			AppLineKeyGlobal.I_UPMU_FLAG	= UPMU_FLAG;
			AppLineKeyGlobal.I_UPMU_TYPE	= upmuType;
			AppLineKeyGlobal.I_DAYS			= E_ABRTG;
			AppLineKeyGlobal.I_AWART		= AWART;

			Logger.debug.println("#####	[Eurp]	APPR_TYPE	:	" + APPR_TYPE);
			Logger.debug.println("#####	[Eurp]	I_DATE		:	" + DataUtil.getCurrentDate());
			Logger.debug.println("#####	[Eurp]	I_PERNR		:	" + empNo);
			Logger.debug.println("#####	[Eurp]	UPMU_FLAG	:	" + UPMU_FLAG);
			Logger.debug.println("#####	[Eurp]	UPMU_TYPE	:	" + upmuType);
			Logger.debug.println("#####	[Eurp]	DAYS		:	" + E_ABRTG);
			Logger.debug.println("#####	[Eurp]	AWART		:	" + AWART);

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisioner(AppLineKeyGlobal);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	public static Vector getAppVector2(String PERNR, String UPMU_TYPE, String APPR_TYPE)
		throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal = new AppLineKeyGlobal();
			AppLineKeyGlobal.I_AWART 	= APPR_TYPE;					// AppLineKeyGlobal.AWART에 화면에서 Application Type 값을 setting.	(USA)
			AppLineKeyGlobal.I_DATUM 	= DataUtil.getCurrentDate();	// 현재일자.
			AppLineKeyGlobal.I_PERNR 	= PERNR;
			AppLineKeyGlobal.I_UPMU_FLAG = UPMU_FLAG;
			AppLineKeyGlobal.I_UPMU_TYPE = UPMU_TYPE;

			Logger.debug.println("#####	[USA]	AWART		:	" + APPR_TYPE);
			Logger.debug.println("#####	[USA]	I_DATE		:	" + DataUtil.getCurrentDate());
			Logger.debug.println("#####	[USA]	I_PERNR		:	" + PERNR);
			Logger.debug.println("#####	[USA]	UPMU_FLAG	:	" + UPMU_FLAG);
			Logger.debug.println("#####	[USA]	UPMU_TYPE	:	" + UPMU_TYPE);

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisioner(AppLineKeyGlobal);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청(퇴직인원의 결재자 가져올때)
	 *
	 * @param empNo
	 *            java.lang.String 사원번호
	 * @param upmuType
	 *            java.lang.String 업무형태
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public static Vector getRetireAppVector(String empNo, String upmuType, String reday) throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal	= new AppLineKeyGlobal();
			AppLineKeyGlobal.I_APPR_TYPE	= APPR_TYPE;
			AppLineKeyGlobal.I_DATUM 		= reday;	// 퇴직일자 - 1일
			AppLineKeyGlobal.I_PERNR 		= empNo;
			AppLineKeyGlobal.I_UPMU_FLAG	= UPMU_FLAG;
			AppLineKeyGlobal.I_UPMU_TYPE	= upmuType;

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisioner(AppLineKeyGlobal);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청
	 *
	 * @param empNo
	 *            java.lang.String 사원번호
	 * @param upmuType
	 *            java.lang.String 업무형태
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppBuild(String empNo, String upmuType) throws GeneralException {

		try {
			AppLineKeyGlobal AppLineKeyGlobal	= new AppLineKeyGlobal();
			AppLineKeyGlobal.I_APPR_TYPE	= APPR_TYPE; 					// ="01"
			AppLineKeyGlobal.I_DATUM 		= DataUtil.getCurrentDate();	// 현재일자.
			AppLineKeyGlobal.I_PERNR 		= empNo;
			AppLineKeyGlobal.I_UPMU_FLAG	= UPMU_FLAG; 					// ="A"
			AppLineKeyGlobal.I_UPMU_TYPE	= upmuType;

			DecisionerRFC func = new DecisionerRFC();
			Vector AppLineData_vt = func.getDecisioner(AppLineKeyGlobal);
			return AppUtil.returnHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector 결제정보 Vector
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppBuild(Vector AppLineData_vt) throws GeneralException {

		try {
			return AppUtil.returnHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 수정
	 *
	 * @param AINF_SEQN
	 *            java.lang.String 결재정보에 할당된 고유번호
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppChange(String AINF_SEQN) throws GeneralException {

		try {
			ApprInfoRFC func = new ApprInfoRFC();
			Vector AppLineData_vt = func.getApproval(AINF_SEQN);
			return AppUtil.returnHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppChange - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 수정
	 *
	 * @param AINF_SEQN
	 *            java.lang.String 결재정보에 할당된 고유번호
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public static Vector getAppChangeVt(String AINF_SEQN) throws GeneralException {

		try {
			ApprInfoRFC func = new ApprInfoRFC();
			Vector AppLineData_vt = func.getApproval(AINF_SEQN);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppChange - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 수정
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector 결제정보 Vector
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppChange(Vector AppLineData_vt) throws GeneralException {

		try {
			return AppUtil.returnHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppChange - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 조회
	 *
	 * @param AINF_SEQN
	 *            java.lang.String 결재정보에 할당된 고유번호
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppDetail(String AINF_SEQN) throws GeneralException {

		try {
			ApprInfoRFC func = new ApprInfoRFC();
			Vector AppLineData_vt = func.getApproval(AINF_SEQN);
			return returnDetailHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppDetail - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 조회
	 *
	 * @param AINF_SEQN
	 *            java.lang.String 결재정보에 할당된 고유번호
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public static Vector getAppDetailVt(String AINF_SEQN) throws GeneralException {

		try {
			ApprInfoRFC func = new ApprInfoRFC();
			Vector AppLineData_vt = func.getApproval(AINF_SEQN);
			return AppLineData_vt;
		} catch (Exception e) {
			Logger.debug.println("Can Not AppDetail - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재신청항목 조회
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector 결제정보 Vector
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppDetail(Vector AppLineData_vt) throws GeneralException {

		try {
			return returnDetailHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppDetail - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 승인완료인경우를 체크하기 위해서(의료비, 장학자금 상세 조회에서 회사지급액 dispaly 여부)
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector 결제정보 Vector
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static boolean getAppState(Vector AppLineData_vt) throws GeneralException {

		try {
			int icnt = 0;

			for (int i = 0; i < AppLineData_vt.size(); i++) {
				AppLineData AppLineData = (AppLineData) AppLineData_vt.get(i);

				DataUtil.fixNull(AppLineData);

				if (AppLineData.APPL_APPR_STAT.equals("A")) {
					icnt++;
				}
			}

			if (icnt == AppLineData_vt.size()) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			Logger.debug.println("Can Not AppState - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}

	/**
	 * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector hris.common.AppLineData 결재정보
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private static String returnDetailHtml(Vector AppLineData_vt) throws GeneralException {

		try {
			StringBuffer sb = new StringBuffer();

			sb.append("<SCRIPT LANGUAGE='JavaScript'>                                                     											\n");
			sb.append("<!--                                                                               														\n");
			sb.append("function chk_APPR_STAT(job) {  /* change => job = 0  , delete => job = 1 */       								\n");
			sb.append("    size = document.form1.app_size.value;                                          											\n");
			sb.append("    var stat = 0;                                                                 														\n");
			sb.append("    for (var i = 0; i < Number(size); i++ ) {                                    													\n");
			sb.append("        if (eval(\"document.form1.APPL_APPR_STAT\"+i+\".value == 'Approved'\")) {								\n");
			sb.append("            stat = stat + 1;                                                       													\n");
			sb.append("        }                                                                          															\n");
			sb.append("    }                                                                              															\n");
			sb.append("    if (job == 0) {                                                                  													\n");
			sb.append("        jobid = 'Modification';                                                            											\n");
			sb.append("    } else if (job == 1) {                                                           													\n");
			sb.append("        jobid = 'Removal';                                                           													\n");
			sb.append("    }                                                                              															\n");
			sb.append("    if (stat == size) {                                                            														\n");
			sb.append("        alert('It has been settled. \\\n\\\n'+jobid+' can not be done.');    												\n");
			sb.append("        return false;                                                              														\n");
			sb.append("    } else if (stat > 0) {                                                         													\n");
			sb.append("     alert('Settling now. \\\n\\\n'+jobid+' can not be done.');         													\n");
			sb.append("        return false;                                                              														\n");
			sb.append("    } else {                                                                       														\n");
			sb.append("        return true;                                                              														\n");
			sb.append("    }                                                                              															\n");
			sb.append("}                                                                                  															\n");
			sb.append("//-->                                                                              														\n");
			sb.append("</SCRIPT>                                                                          													\n");
			sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">  							\n");
			sb.append(" <!-- 결재자 입력 테이블 시작-->                                                   													\n");
			sb.append(" <table width=\"780\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">           									\n");
			sb.append("   <tr>                                                                            														\n");
			sb.append("     <td>                                                                          														\n");
			sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"table02\">					\n");
			sb.append("         <tr>                                                                      														\n");
			sb.append("           <td class=\"td03\" width=\"120\">                                       												\n");
			sb.append("             Approval Post                                                   															\n");
			sb.append("           </td>                                                                   														\n");
			sb.append("           <td class=\"td03\" width=\"100\">Name&nbsp;</td>                             								\n");
			sb.append("           <td class=\"td03\" width=\"270\">Org.Unit Name</td>                            								\n");
			sb.append("           <td class=\"td03\" width=\"100\">Res.of Office</td>                              								\n");
			sb.append("           <td class=\"td03\" width=\"100\">Approved Date</td>                             							\n");
			sb.append("           <td class=\"td03\" width=\"80\">Status</td>                              										\n");
			sb.append("           <td class=\"td03\" width=\"160\">Tel.Number at Work</td>                              					\n");
			sb.append("         </tr>                                                                     														\n");

			for (int i = 0; i < AppLineData_vt.size(); i++) {
				AppLineData AppLineData = (AppLineData) AppLineData_vt.get(i);
				DataUtil.fixNull(AppLineData);
				String APPL_APPR_DATA = AppLineData.APPL_APPR_DATE.equals("") ? ""
													: AppLineData.APPL_APPR_DATE.equals("0000-00-00") ? ""
													: WebUtil.printDate(AppLineData.APPL_APPR_DATE, ".");

				String APPL_APPR_STAT = "";
				if (AppLineData.APPL_APPR_STAT.equals("A")) {
					APPL_APPR_STAT = "Approved";
				} else if (AppLineData.APPL_APPR_STAT.equals("R")) {
					APPL_APPR_STAT = "Reject";
				} else {
					APPL_APPR_STAT = "Not Approved";
				}

				sb.append(" <tr align=\"center\">                                                                                                        	\n");
				sb.append("   <td class=\"td04\">                                                                                                       	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NAME" + i + "\" size=\"15\" class=\"input02\" value=\""
										+ AppLineData.APPL_APPU_NAME
										+ "\" style=\"text-align:center\" readonly>  																		\n");
				sb .append(AppLineData.APPL_APPU_NAME + "\n");
				sb.append("   </td>                                                                                                                       		\n");
				sb.append("   <td class=\"td04\">                                                                                                       	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_ENAME" + i + "\" size=\"35\" class=\"input02\" value=\""
										+ AppLineData.APPL_ENAME
										+ "\" style=\"text-align:center\" readonly>          																\n");
				sb.append(AppLineData.APPL_ENAME + "\n");
				sb.append("   </td>                                                                                                                      		\n");
				sb.append("   <td class=\"td04\">                                                                                                        	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_ORGTX" + i + "\" size=\"28\" class=\"input02\" value=\""
										+ AppLineData.APPL_ORGTX
										+ "\" style=\"text-align:center\" readonly>          																\n");
				sb.append(AppLineData.APPL_ORGTX + "\n");
				sb.append("   </td>                                                                                                                     			\n");
				sb.append("   <td class=\"td04\">                                                                                                      		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKKT" + i + "\" size=\"10\" class=\"input02\" value=\""
										+ AppLineData.APPL_JIKKT
										+ "\" style=\"text-align:center\" readonly>           																\n");
				sb.append(AppLineData.APPL_JIKKT + "\n");
				sb.append("   </td>                                                                                                                         		\n");
				sb.append("   <td class=\"td04\">                                                                                                   		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKWT" + i + "\" size=\"14\" class=\"input02\" value=\""
										+ APPL_APPR_DATA
										+ "\" style=\"text-align:center\" readonly >  																		\n");
				sb.append(APPL_APPR_DATA + "\n");
				sb.append("   </td>                                                                                                      						\n");
				sb.append("   <td class=\"td04\">                                                                                                       	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_STAT" + i + "\" size=\"9\" class=\"input02\" value=\""
										+ APPL_APPR_STAT
										+ "\" style=\"text-align:center\" readonly>              															\n");
				sb.append(APPL_APPR_STAT + "\n");
				sb.append("   </td>                                                                                                                     			\n");
				sb.append("   <td class=\"td04\">                                                                                                         	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_TELNUMBER" + i + "\" size=\"20\" class=\"input02\" value=\""
										+ AppLineData.APPL_TELNUMBER
										+ "\" style=\"text-align:center\" readonly>  																		\n");
				sb.append(AppLineData.APPL_TELNUMBER + "\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_DATE" + i + "\" size=\"10\" class=\"input02\" value=\""
										+ APPL_APPR_DATA
										+ "\" style=\"text-align:center\" readonly>              															\n");
				// sb.append(" <input type=\"hidden\" name=\"APPL_APPR_STAT"+ i +"\" size=\"8\" class=\"input02\" value=\""
				//						+ APPL_APPR_STAT
				// 						+ "\" style=\"text-align:center\" readonly> 																		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN" + i + "\" value=\"" + AppLineData.APPL_APPR_SEQN + "\" >	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE" + i + "\" value=\"" + AppLineData.APPL_APPU_TYPE + "\" >	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB" + i + "\" value=\"" + AppLineData.APPL_PERNR + "\" >  		\n");
				sb.append("   </td>                                                                                                                         		\n");
				sb.append(" </tr>                                                                                                                           		\n");
			}
			sb.append("       </table>                  																										\n");
			sb.append("     </td>                       																											\n");
			sb.append("   </tr>                         																											\n");
			sb.append(" </table>                        																										\n");
			sb.append(" <!-- 결재자 입력 테이블 시작--> 																									\n");
			sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\"" + AppLineData_vt.size() + "\">  							\n");
			sb.append("");

			return sb.toString();
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}


	/**	[기존]
	 * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector hris.common.AppLineData 결재정보
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private static String returnHtml_old(Vector AppLineData_vt) throws GeneralException {

		try {
			StringBuffer sb = new StringBuffer();

			sb.append(" <!-- 결재자 입력 테이블 시작-->                                                                								\n");
			sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">    						\n");
			sb.append(" <script language=\"javascript\">                                                               								\n");
			sb.append(" function change_AppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER){						\n");
			sb.append("    eval(\"document.form1.APPL_PERNR\"+index+\".value = PERNR\");                         						\n");
			sb.append("    eval(\"document.form1.APPL_APPU_NUMB\" + index + \".value = PERNR\");              					\n");
			sb.append("    eval(\"document.form1.APPL_ENAME\" + index + \".value = ENAME\");                    					\n");
			sb.append("    eval(\"document.form1.APPL_ORGTX\" + index + \".value = ORGTX\");                    					\n");
			sb.append("    eval(\"document.form1.APPL_JIKKT\" + index + \".value = TITEL\");                       					\n");
			sb.append("    eval(\"document.form1.APPL_JIKWT\" + index + \".value = TITL2\");                      					\n");
			sb.append("    eval(\"document.form1.APPL_TELNUMBER\" + index + \".value = TELNUMBER\");       					\n");
			sb.append(" }                                                                                              										\n");
			sb.append("  function open_search(index) {                                                                 								\n");
			sb.append("      objid = eval(\"document.form1.APPL_OBJID\" + index + \".value\");                      					\n");
			sb.append("      theURL = \""
									+ WebUtil.JspURL
									+ "common/AppLinePop.jsp?index=\" + index + \"&objid=\" + objid;      									\n");
			sb.append("      window.open(theURL,\"essSearch\",\"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100\");	\n");
			sb.append("  }                                                                                             										\n");
			sb.append(" function check_empNo(){                                                                      								\n");
			sb.append("     var size = document.form1.app_size.value;                                                  							\n");
			sb.append("     if (size == 0) {                                                                           										\n");
			sb.append("          alert(\"No information on settler.\");                                                   							\n");
			sb.append("          return true;                                                                          										\n");
			sb.append("     }                                                                                          										\n");
			sb.append("     for (i = 0; i<size; i++) {                                                              										\n");
			sb.append("         val = eval(\"document.form1.APPL_APPU_NUMB\" + i + \".value\");                  						\n");
			sb.append("         if (val == \"\" || val == null || val == \"00000000\") {                               							\n");
			sb.append("          alert(\"Please settler's name.\");                                                 									\n");
			sb.append("             return true;                                                                       										\n");
			sb.append("         }                                                                                      										\n");
			sb.append("     }                                                                                          										\n");
			sb.append("     for (i = 0; i < size; i++) {                                                               									\n");
			sb.append("         for (j = 0; j < size; j++) {                                                            									\n");
			sb.append("             if (i != j) {                                                                     											\n");
			sb.append("                 if (eval(\"document.form1.APPL_APPU_TYPE\"+i+\".value != \'02\' && document.form1.APPL_APPU_TYPE\"+j+\".value != \'02\' \")){	\n");
			sb.append("                     //if (eval(\"document.form1.APPL_PERNR\"+i+\".value == document.form1.APPL_PERNR\"+j+\".value \")){  								\n");
			sb.append("                         //alert(\"Settler’s redundancy input.\");                             								\n");
			sb.append("                         //return true;                                                           									\n");
			sb.append("                     //}                                                                          										\n");
			sb.append("                 }                                                                              										\n");
			sb.append("             }                                                                                  										\n");
			sb.append("         }                                                                                      										\n");
			sb.append("     }                                                                                     												\n");
			sb.append("     return false;                                                                              										\n");
			sb.append(" }                                                                                              										\n");
			sb.append(" </script>                                                                                      										\n");

			sb.append(" <table width=\"780\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                      					\n");
			sb.append("   <tr>                                                                                         										\n");
			sb.append("     <td>                                                                                       										\n");
			sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"table02\">				\n");
			sb.append("         <tr>                                                                                  										\n");
			sb.append("           <td class=\"td03\" width=\"120\">Approval Post</td>                                  					\n");
			sb.append("           <td class=\"td03\">Name</td>  																					\n");
			sb.append("           <td class=\"td03\">Org.Unit Name</td>                                         								\n");
			sb.append("           <td class=\"td03\">Res.of Office</td>                                          									\n");
			sb.append("           <td class=\"td03\">Title of Level</td>                                          									\n");
			sb.append("           <td class=\"td03\">Tel.Number at Work</td>                                         							\n");
			sb.append("         </tr>                                                                                  										\n");

			for (int i = 0; i < AppLineData_vt.size(); i++) {
				AppLineData AppLineData = (AppLineData) AppLineData_vt.get(i);
				DataUtil.fixNull(AppLineData);

				//String style = (AppLineData.APPL_APPU_TYPE).equals("02") ? "input02" : "input04";

				sb.append(" <tr align=\"center\">                                                                              							\n");
				sb.append("   <td class=\"td04\">                                                                           							\n");
				sb.append("     <input type=\"text\" name=\"APPL_APPU_NAME" + i + "\" value=\""
										+ AppLineData.APPL_APPU_NAME
										+ "\" size=\"15\" class=\"input02\" style=\"text-align:center\" readonly >    						\n");
				//sb .append(AppLineData.APPL_APPU_NAME + "\n");
				sb.append("   </td>																															\n");
				sb.append("   <td class=\"td04\" nowrap>                                                                       						\n");
				sb.append("     <input type=\"text\" name=\"APPL_ENAME" + i + "\" value=\""
										+ AppLineData.APPL_ENAME
										+ "\" size=\"17\" class=\"input02\""
				//						+ style
										+ " \" readonly style=\"text-align:center;padding-top:2px;\">       									\n");
				//sb.append(AppLineData.APPL_ENAME + "\n");
				if ((AppLineData.APPL_APPU_TYPE).equals("01")) {
					sb.append("     <a href=\"javascript:;\" onClick=\"open_search(" + i + ");\">                     						\n");
					sb.append("       <img src=\"" + WebUtil.ImageURL + "btn_serch.gif\" align=\"absmiddle\" border=\"0\" /></a>	\n");
				}
				sb.append("   </td>                                                                                                    						\n");
				sb.append(" <td class=\"td04\">                                                                                   						\n");
				sb.append("    <input type=\"text\" name=\"APPL_ORGTX" + i + "\" value=\""
										+ AppLineData.APPL_ORGTX
										+ "\" size=\"30\" class=\"input02\" readonly style=\"text-align:center;padding-top:2px;\">		\n");
				//sb.append(AppLineData.APPL_ORGTX + " \n");
				sb.append("   </td>                                                                                                    						\n");
				sb.append("   <td class=\"td04\">                                                                                   					\n");
				sb.append("     <input type=\"text\" name=\"APPL_JIKKT" + i + "\" value=\""
										+ AppLineData.APPL_JIKKT
										+ "\" size=\"14\" class=\"input02\" style=\"text-align:center;padding-top:2px;\" readonly >	\n");
				//sb.append(AppLineData.APPL_JIKKT + " \n");
				sb.append("   </td>                                                                                                     						\n");
				sb.append("   <td class=\"td04\">                                                                                     					\n");
				sb.append("     <input type=\"text\" name=\"APPL_JIKWT" + i + "\" value=\""
										+ AppLineData.APPL_JIKWT
										+ "\" size=\"14\" class=\"input02\" style=\"text-align:center;padding-top:2px;\" readonly >	\n");
				//sb.append(AppLineData.APPL_JIKWT + " \n");
				sb.append("   </td>                                                                                                                 			\n");
				sb.append("   <td class=\"td04\">                                                                                          				\n");
				sb.append("     <input type=\"text\" name=\"APPL_TELNUMBER" + i + "\" value=\""
										+ AppLineData.APPL_TELNUMBER
										+ "\" size=\"18\" class=\"input02\" style=\"text-align:center\" readonly >  							\n");
				//sb.append(AppLineData.APPL_TELNUMBER + " \n");
				sb.append("     <input type=\"hidden\" name=\"APPL_UPMU_FLAG" + i + "\" value=\"" + UPMU_FLAG + "\" >          						\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE" + i + "\" value=\"" + AppLineData.APPL_APPU_TYPE + "\" >		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_TYPE" + i + "\" value=\"" + AppLineData.APPL_APPR_TYPE + "\" >     	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN" + i + "\" value=\"" + AppLineData.APPL_APPR_SEQN + "\" >		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_PERNR" + i + "\" value=\"" + AppLineData.APPL_PERNR + "\" >                 	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_OTYPE" + i + "\" value=\"" + AppLineData.APPL_OTYPE + "\" >            		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_OBJID" + i + "\" value=\"" + AppLineData.APPL_OBJID + "\" >                 		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_STEXT" + i + "\" value=\"" + AppLineData.APPL_STEXT + "\" >             		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKWE" + i + "\" value=\"" + AppLineData.APPL_JIKWE + "\" >                     \n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKKB" + i + "\" value=\"" + AppLineData.APPL_JIKKB + "\" >                      	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_DATE" + i + "\" value=\"" + AppLineData.APPL_APPR_DATE + "\" >     	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_STAT" + i + "\" value=\"" + AppLineData.APPL_APPR_STAT + "\" >		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB" + i + "\" value=\"" + AppLineData.APPL_PERNR + "\" >           	\n");
				sb.append("   </td>                                                                                                                     		\n");
				sb.append(" </tr>                                                                                                                       		\n");
			}
			sb.append("        </table>                  																									\n");
			sb.append("      </td>                       																									\n");
			sb.append("    </tr>                         																										\n");
			sb.append("  </table>                       																									\n");
			sb.append("  <!-- 결재자 입력 테이블 끝  --> 																								\n");
			sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\"" + AppLineData_vt.size() + "\">  						\n");

			return sb.toString();
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	public static String iso2Unicode(String isoStr) throws UnsupportedEncodingException {

		if (isoStr == null || isoStr.equals(""))
			return "";
		return new String(isoStr.getBytes("iso-8859-1"), "utf-8");
	}

	public static Object initEntity(Object object) {

		Field[] f = object.getClass().getDeclaredFields();
		for (int i = 0; i < f.length; i++) {
			try {
				f[i].set(object, "&nbsp;");
			} catch (IllegalArgumentException e) {
				Logger.err.println(e.getMessage());
			} catch (IllegalAccessException e) {
				Logger.err.println(e.getMessage());
			}
		}
		return object;
	}

	public static Object initEntity(Object object, String target) {

		Field[] f = object.getClass().getDeclaredFields();
		for (int i = 0; i < f.length; i++) {
			try {
				f[i].set(object, target);
			} catch (IllegalArgumentException e) {
				Logger.err.println(e.getMessage());
			} catch (IllegalAccessException e) {
				Logger.err.println(e.getMessage());
			}
		}
		return object;
	}

	public static Object nvlEntity(Object object) {

		Field[] f = object.getClass().getDeclaredFields();
		for (int i = 0; i < f.length; i++) {
			try {
				if (f[i].get(object) == null || f[i].get(object).equals("")) {
					f[i].set(object, "0");
				}
			} catch (IllegalArgumentException e) {
				Logger.err.println(e.getMessage());
			} catch (IllegalAccessException e) {
				Logger.err.println(e.getMessage());
			}
		}
		return object;
	}

	public static String escape(String src) {

		int i;
		char j;
		StringBuffer tmp = new StringBuffer();
		tmp.ensureCapacity(src.length() * 6);
		for (i = 0; i < src.length(); i++) {
			j = src.charAt(i);
			if (Character.isDigit(j) || Character.isLowerCase(j)
					|| Character.isUpperCase(j))
				tmp.append(j);
			else if (j < 256) {
				tmp.append("%");
				if (j < 16)
					tmp.append("0");
				tmp.append(Integer.toString(j, 16));
			} else {
				tmp.append("%u");
				tmp.append(Integer.toString(j, 16));
			}
		}
		return tmp.toString();
	}

	public static Object initEntity(Object object, String source, String target) {

		Field[] f = object.getClass().getDeclaredFields();
		for (int i = 0; i < f.length; i++) {
			try {
				if (f[i].get(object).equals(source)) {
					f[i].set(object, target);
				}
			} catch (IllegalArgumentException e) {
				Logger.err.println(e.getMessage());
			} catch (IllegalAccessException e) {
				Logger.err.println(e.getMessage());
			}
		}
		return object;
	}

	public static boolean checkEnglish(String txt) {

		String val = txt;
		for (int i = 0; i < val.length(); i++) {
			char codeChr = val.charAt(i);
			if (codeChr > 255) {
				return false;
			}
		}
		return true;
	}

	public static Vector mailData(String empNo) throws GeneralException {

		Vector ret = new Vector();
		PersonInfoRFC numfunc = new PersonInfoRFC();
		PersonData phonenumdata;
		phonenumdata = (PersonData) numfunc.getPersonInfo(empNo);
		ret.addElement(phonenumdata.E_AUTHORIZATION);
		ret.addElement(phonenumdata.E_MOLGA);
		return ret;
	}

}
