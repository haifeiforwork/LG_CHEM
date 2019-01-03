/********************************************************************************/
/*                                                                              															   */
/*   System Name  : MSS                                                         													   */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  : 공통                                                        */
/*   Program Name : 결재정보                                                    */
/*   Program ID     : AppUtil                                                     */
/*   Description     : 결재항목에 관한 프로세스를 실행하는 Class                   */
/*   Note             :                                                             */
/*   Creation        : 2001-12-13  박영락                                          */
/*   Update          : 2005-02-14  윤정현                                          */
/*                      : 2005-04-14  윤정현(퇴직자 결재정보 가져오는 것 추가)        */
/*                      : 2017-09-28  eunha  [CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림   */
/*                      : 2018-03-19  강동민  @PJ.광저우 법인(G570) Roll-Out
/*                      : 2018-07-26 rdcamel [CSR ID:3748125] g-mobile 휴가 신청 시 결재 라인 오류 건 수정 */
/*                      : 2018-06-07 변지현 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout */
/*                      : 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out */
/********************************************************************************/

package hris.common.util;

import com.common.Global;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.N.AES.AESgenerUtil;
import hris.common.AppLineData;
import hris.common.AppLineKey;
import hris.common.approval.ApprovalLineInput;
import hris.common.rfc.ApprInfoRFC;
import hris.common.rfc.DecisionerRFC;
import org.apache.commons.lang.StringUtils;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.Vector;

public class AppUtil {

    private final static String  APPR_TYPE  = "01";
    private final static String  UPMU_FLAG  = "A";

    /**
     * 결재신청
     * @param empNo java.lang.String 사원번호
     * @param upmuType java.lang.String 업무형태
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:3748125] input parameter 수정
     */
	protected static Global g = Utils.getBean("global");
    public static Vector getAppVector( String empNo, String upmuType ) throws GeneralException  {

        try{
            /*[CSR ID:3748125]
            AppLineKey appLineKey = new AppLineKey();
            appLineKey.APPR_TYPE  = APPR_TYPE;
            appLineKey.I_DATE     = DataUtil.getCurrentDate();   //현재일자.
            appLineKey.I_PERNR    = empNo;
            appLineKey.UPMU_FLAG  = UPMU_FLAG;
            appLineKey.UPMU_TYPE  = upmuType;*/
        	ApprovalLineInput appLineKey = new ApprovalLineInput();
            appLineKey.I_APPR_TYPE  = APPR_TYPE;
            appLineKey.I_DATUM     = DataUtil.getCurrentDate();   //현재일자.
            appLineKey.I_PERNR    = empNo;
            appLineKey.I_UPMU_FLAG  = UPMU_FLAG;
            appLineKey.I_UPMU_TYPE  = upmuType;

            DecisionerRFC func    = new DecisionerRFC();
            Vector AppLineData_vt = func.getDecisioner( appLineKey );
            return AppLineData_vt;
        } catch(Exception e){
            Logger.debug.println( "Can Not AppBuild - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    //ghr method 추가
	public static Vector getAppVector(String empNo, String upmuType, String work_date, String hours)
	throws GeneralException {

	try {
		/*[CSR ID:3748125]
		AppLineKey appLineKey = new AppLineKey();
		appLineKey.APPR_TYPE	= APPR_TYPE;
		appLineKey.I_DATE 		= work_date;	// 현재일자.
		appLineKey.I_PERNR 		= empNo;
		appLineKey.UPMU_FLAG	= UPMU_FLAG;
		appLineKey.UPMU_TYPE	= upmuType;
		appLineKey.ANZHL 		= hours;*/
		ApprovalLineInput appLineKey = new ApprovalLineInput();
        appLineKey.I_APPR_TYPE  = APPR_TYPE;
        appLineKey.I_DATUM     = DataUtil.getCurrentDate();   //현재일자.
        appLineKey.I_PERNR    = empNo;
        appLineKey.I_UPMU_FLAG  = UPMU_FLAG;
        appLineKey.I_UPMU_TYPE  = upmuType;
        appLineKey.I_ANZHL 		= hours;



		Logger.debug.println("#####	APPR_TYPE	:	" + APPR_TYPE);
		Logger.debug.println("#####	I_DATE		:	" + work_date);
		Logger.debug.println("#####	I_PERNR		:	" + empNo);
		Logger.debug.println("#####	UPMU_FLAG	:	" + UPMU_FLAG);
		Logger.debug.println("#####	UPMU_TYPE	:	" + upmuType);
		Logger.debug.println("#####	ANZHL		:	" + hours);

		DecisionerRFC func = new DecisionerRFC();
		Vector AppLineData_vt = func.getDecisionerExt(appLineKey);
		return AppLineData_vt;
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
	/*public static String getAppBuild(Vector AppLineData_vt) throws GeneralException {

		try {
			 return returnHtml( AppLineData_vt ,E_PERNR);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}*/
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
    /**
     * 결재신청(퇴직인원의 결재자 가져올때)
     * @param empNo java.lang.String 사원번호
     * @param upmuType java.lang.String 업무형태
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public static Vector getRetireAppVector( String empNo, String upmuType, String reday ) throws GeneralException  {

        try{
            AppLineKey appLineKey = new AppLineKey();
            appLineKey.APPR_TYPE  = APPR_TYPE;
            appLineKey.I_DATE     = reday;   //퇴직일자 - 1일
            appLineKey.I_PERNR    = empNo;
            appLineKey.UPMU_FLAG  = UPMU_FLAG;
            appLineKey.UPMU_TYPE  = upmuType;

            DecisionerRFC func    = new DecisionerRFC();
            Vector AppLineData_vt = func.getDecisioner( appLineKey );
            return AppLineData_vt;
        } catch(Exception e){
            Logger.debug.println( "Can Not AppBuild - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청
     * @param empNo java.lang.String 사원번호
     * @param upmuType java.lang.String 업무형태
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppBuild( String empNo, String upmuType ) throws GeneralException  {

        try{
            AppLineKey appLineKey = new AppLineKey();
            appLineKey.APPR_TYPE  = APPR_TYPE;
            appLineKey.I_DATE     = DataUtil.getCurrentDate();   //현재일자.
            appLineKey.I_PERNR    = empNo;
            appLineKey.UPMU_FLAG  = UPMU_FLAG;
            appLineKey.UPMU_TYPE  = upmuType;

            DecisionerRFC func    = new DecisionerRFC();
            Vector ret = func.getDecisionerA( appLineKey );
            Vector AppLineData_vt =  (Vector)ret.get(0);
            String E_PERNR =  (String)ret.get(1);

            return returnHtml( AppLineData_vt ,E_PERNR);
        } catch(Exception e){
            Logger.debug.println( "Can Not AppBuild - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppBuild( Vector AppLineData_vt,String E_PERNR ) throws GeneralException  {
        try{
            return returnHtml( AppLineData_vt,E_PERNR );
        } catch(Exception e){
            Logger.debug.println( "Can Not AppBuild - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

	/**
	 * 결재신청(해외소스 통합)
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector 결제정보 Vector
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	public static String getAppBuild(Vector AppLineData_vt) throws GeneralException {

		try {
			return returnHtml(AppLineData_vt);
		} catch (Exception e) {
			Logger.debug.println("Can Not AppBuild - Exception :" + e.toString());
			throw new GeneralException(e);
		}
	}
    /**
     * 결재신청
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppBuildNot( Vector AppLineData_vt ) throws GeneralException  {
        try{
            return returnHtmlNot( AppLineData_vt );
        } catch(Exception e){
            Logger.debug.println( "Can Not AppBuild - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 수정
     * @param AINF_SEQN java.lang.String 결재정보에 할당된 고유번호
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppChange( String AINF_SEQN ) throws GeneralException {
        try{
            ApprInfoRFC func = new ApprInfoRFC();
            Vector ret = func.getApprovalA( AINF_SEQN );

            Vector AppLineData_vt =  (Vector)ret.get(0);
            String E_PERNR =  (String)ret.get(1);

            return returnHtml( AppLineData_vt,E_PERNR );
        } catch(Exception e){
            Logger.debug.println( "Can Not AppChange - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 수정
     * @param AINF_SEQN java.lang.String 결재정보에 할당된 고유번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public static Vector getAppChangeVt( String AINF_SEQN ) throws GeneralException {
        try{
            ApprInfoRFC func = new ApprInfoRFC(SAPType.LOCAL);

            if("7".equals(StringUtils.substring(AINF_SEQN, 0, 1))) {
                func.setSapType(SAPType.GLOBAL);
            }

            Vector AppLineData_vt = func.getApproval( AINF_SEQN );
            return AppLineData_vt;
        } catch(Exception e){
            Logger.error(e);
            Logger.debug.println( "Can Not AppChange - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 수정
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppChange( Vector AppLineData_vt ,String E_PERNR) throws GeneralException {
        try{
            return returnHtml( AppLineData_vt, E_PERNR );
        } catch(Exception e){
            Logger.debug.println( "Can Not AppChange - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 조회
     * @param AINF_SEQN java.lang.String 결재정보에 할당된 고유번호
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppDetail( String AINF_SEQN ) throws GeneralException {
        try{
            ApprInfoRFC func = new ApprInfoRFC();
            Vector AppLineData_vt = func.getApproval( AINF_SEQN );
            return returnDetailHtml( AppLineData_vt );
        } catch( Exception e){
            Logger.debug.println( "Can Not AppDetail - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 조회
     * @param AINF_SEQN java.lang.String 결재정보에 할당된 고유번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public static Vector getAppDetailVt( String AINF_SEQN ) throws GeneralException {
        try{
            ApprInfoRFC func = new ApprInfoRFC();
            Vector AppLineData_vt = func.getApproval( AINF_SEQN );
            return AppLineData_vt;
        } catch( Exception e){
            Logger.debug.println( "Can Not AppDetail - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 조회
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppDetail( Vector AppLineData_vt ) throws GeneralException {
        try{
            return returnDetailHtml( AppLineData_vt );
        } catch( Exception e){
            Logger.debug.println( "Can Not AppDetail - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재신청항목 조회
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static String getAppOrgDetail( Vector AppLineData_vt ) throws GeneralException {
        try{
            return returnOrgDetailHtml( AppLineData_vt );
        } catch( Exception e){
            Logger.debug.println( "Can Not OrgAppDetail - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }
    /**
     * 승인완료인경우를 체크하기 위해서(의료비, 장학자금 상세 조회에서 회사지급액 dispaly 여부)
     * @param AppLineData_vt java.util.Vector 결제정보 Vector
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public static boolean getAppState( Vector AppLineData_vt ) throws GeneralException {
        try{
            int icnt = 0;

            for( int i = 0 ; i < AppLineData_vt.size() ; i++ ) {
                AppLineData appLineData = (AppLineData)AppLineData_vt.get(i);

                DataUtil.fixNull( appLineData );

                if( appLineData.APPL_APPR_STAT.equals("A") ) {
                    icnt++;
                }
            }

            if( icnt == AppLineData_vt.size() ) {
                return true;
            } else {
                return false;
            }
        } catch( Exception e){
            Logger.debug.println( "Can Not AppState - Exception :"+e.toString() );
            throw new GeneralException(e);
        }
    }

    /**
     * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
     * @param AppLineData_vt java.util.Vector hris.common.AppLineData 결재정보
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private static String returnDetailHtml( Vector AppLineData_vt ) throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();

            sb.append("<SCRIPT LANGUAGE='JavaScript'>                                                     \n");
            sb.append("<!--                                                                               \n");
            sb.append("function chk_APPR_STAT(job) {  /* change => job = 0  , delete => job = 1 */        \n");
            sb.append("    size = document.form1.app_size.value;                                          \n");
            sb.append("    var stat = 0 ;                                                                 \n");
            sb.append("    for ( var i = 0 ; i < Number(size) ; i++ ){                                    \n");
            sb.append("        if ( eval(\"document.form1.APPL_APPR_STAT\"+i+\".value == '승인'\") ) {    \n");
            sb.append("            stat = stat + 1;                                                       \n");
            sb.append("        }                                                                          \n");
            sb.append("    }                                                                              \n");
            sb.append("    if(job == 0){                                                                  \n");
            sb.append("        jobid = '수정';                                                            \n");
            sb.append("    } else if(job == 1){                                                           \n");
            sb.append("        jobid = '삭제';                                                            \n");
            sb.append("    }                                                                              \n");
            sb.append("    if( stat == size ){                                                            \n");
            sb.append("        alert('이미 결재가 완료되었습니다. \\\n\\\n'+jobid+'할 수 없습니다. ');    \n");
            sb.append("        return false;                                                              \n");
            sb.append("    } else if( stat > 0 ){                                                         \n");
            sb.append("     alert('이미 결재가 진행중입니다. \\\n\\\n'+jobid+'할 수 없습니다. ');         \n");
            sb.append("        return false;                                                              \n");
            sb.append("    } else {                                                                       \n");
            sb.append("        return true;                                                               \n");
            sb.append("    }                                                                              \n");
            sb.append("}                                                                                  \n");
            sb.append("//-->                                                                              \n");
            sb.append("</SCRIPT>                                                                          \n");

            sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">  \n");
            sb.append(" <!-- 결재자 입력 테이블 시작-->                                                   \n");
            sb.append(" <div class=table>                                                                                     \n");
            sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"listTable\"> \n");
            sb.append("         <tr>                                                                      \n");
            sb.append("           <th class=\"th03\" width=\"100\">                                       \n");
            sb.append("             <p>결재자 구분</p>                                                    \n");
            sb.append("           </th>                                                                   \n");
            sb.append("           <th class=\"th03\" width=\"90\">성 명</th>                             \n");
            sb.append("           <th class=\"th03\" width=\"200\">부서명</th>                            \n");
            sb.append("           <th class=\"th03\" width=\"80\">직 책</th>                              \n");
            sb.append("           <th class=\"th03\" width=\"90\">승인일</th>                             \n");
            sb.append("           <th class=\"th03\" width=\"80\">상 태</th>                              \n");
            sb.append("           <th class=\"th03\" width=\"140\">연락처</th>                            \n");
            sb.append("         </tr>                                                                     \n");
            for( int i = 0; i < AppLineData_vt.size(); i++ ) {
                AppLineData appLineData = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( appLineData );
                String APPL_APPR_DATA = appLineData.APPL_APPR_DATE.equals("") ? "" : appLineData.APPL_APPR_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(appLineData.APPL_APPR_DATE, ".");
                String APPL_APPR_STAT = "";
                if (appLineData.APPL_APPR_STAT.equals("A")) {
                    APPL_APPR_STAT ="승인";
                } else if (appLineData.APPL_APPR_STAT.equals("R")) {
                    APPL_APPR_STAT ="반려";
                } else {
                    APPL_APPR_STAT ="미결";
                }

                sb.append(" <tr align=\"center\">                                                                                                                       \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_APPU_NAME"+ i +"\" size=\"12\" class=\"input02\" value=\""+ appLineData.APPL_APPU_NAME +"\" style=\"text-align:center\" readonly>  \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_ENAME"+ i +"\" size=\"10\" class=\"input02\" value=\""+ appLineData.APPL_ENAME +"\" style=\"text-align:center\" readonly>          \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_ORGTX"+ i +"\" size=\"28\" class=\"input02\" value=\""+ appLineData.APPL_ORGTX +"\" readonly>          \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_TITL2"+ i +"\" size=\"10\" class=\"input02\" value=\""+ appLineData.APPL_TITL2 +"\" style=\"text-align:center\" readonly>           \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_APPR_DATE"+ i +"\" size=\"10\" class=\"input02\" value=\""+ APPL_APPR_DATA +"\" style=\"text-align:center\" readonly>              \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_APPR_STAT"+ i +"\" size=\"8\" class=\"input02\" value=\""+ APPL_APPR_STAT + "\" style=\"text-align:center\" readonly>              \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append("     <input type=\"text\" name=\"APPL_TELNUMBER"+ i +"\" size=\"20\" class=\"input02\" value=\""+ appLineData.APPL_TELNUMBER +"\" style=\"text-align:center\" readonly>  \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN"+ i +"\" value=\""+ appLineData.APPL_APPR_SEQN +"\" >                                      \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE"+ i +"\" value=\""+ appLineData.APPL_APPU_TYPE +"\" >                                      \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB"+ i +"\" value=\""+ appLineData.APPL_PERNR +"\" >                                          \n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append(" </tr>                                                                                                                                       \n");
            }

            sb.append("       </table>                  \n");
            sb.append("     </div>                       \n");
            sb.append(" <!-- 결재자 입력 테이블 시작--> \n");
            sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\""+ AppLineData_vt.size() +"\">  \n");
            sb.append("");

            return sb.toString();
        } catch( Exception e){
            throw new GeneralException(e);
        }
    }
	/**
	 * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
	 * 해외통합
	 * @param AppLineData_vt
	 *            java.util.Vector hris.common.AppLineData 결재정보
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private static String returnHtml_old(Vector AppLineData_vt) throws GeneralException {

		try {
			StringBuffer sb = new StringBuffer();

			sb.append(" <!-- 결재자 입력 테이블 시작-->                                                                							\n");
			sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">    					\n");
			sb.append(" <script language=\"javascript\">                                                               							\n");
			sb.append(" function change_AppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER){					\n");
			sb.append("    eval(\"document.form1.APPL_PERNR\"+index+\".value = PERNR\");                               			\n");
			sb.append("    eval(\"document.form1.APPL_APPU_NUMB\" + index + \".value = PERNR\");                        		\n");
			sb.append("    eval(\"document.form1.APPL_ENAME\" + index + \".value = ENAME\");                               		\n");
			sb.append("    eval(\"document.form1.APPL_ORGTX\" + index + \".value = ORGTX\");                               		\n");
			sb.append("    eval(\"document.form1.APPL_JIKKT\" + index + \".value = TITEL\");                               		\n");
			sb.append("    eval(\"document.form1.APPL_JIKWT\" + index + \".value = TITL2\");                               		\n");
			sb.append("    eval(\"document.form1.APPL_TELNUMBER\" + index + \".value = TELNUMBER\");                 		\n");
			sb.append(" }                                                                                              									\n");
			sb.append("  function open_search(index) {                                                                 							\n");
			sb.append("      objid = eval(\"document.form1.APPL_OBJID\" + index + \".value\");                             			\n");
			sb.append("      theURL = \""
									+ WebUtil.JspURL
									+ "common/AppLinePop.jsp?index=\" + index + \"&objid=\" + objid;      								\n");
			sb.append("      window.open(theURL,\"essSearch\",\"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100\");	\n");
			sb.append("  }                                                                                             									\n");
			sb.append(" function check_empNo(){                                                                      							\n");
			sb.append("     var size = document.form1.app_size.value;                                                  						\n");
			sb.append("     if (size == 0) {                                                                           									\n");
			sb.append("          alert(\"No information on settler.\");                                                   						\n");
			sb.append("          return true;                                                                          									\n");
			sb.append("     }                                                                                          									\n");
			sb.append("     for (i = 0; i<size; i++) {                                                              									\n");
			sb.append("         val = eval(\"document.form1.APPL_APPU_NUMB\" + i + \".value\");                            		\n");
			sb.append("         if (val == \"\" || val == null || val == \"00000000\") {                               						\n");
			sb.append("          alert(\"Please settler's name.\");                                                 								\n");
			sb.append("             return true;                                                                       									\n");
			sb.append("         }                                                                                      									\n");
			sb.append("     }                                                                                          									\n");
			sb.append("     for (i = 0; i < size; i++) {                                                               								\n");
			sb.append("         for (j = 0; j < size; j++) {                                                            								\n");
			sb.append("             if (i != j) {                                                                     										\n");
			sb.append("                 if (eval(\"document.form1.APPL_APPU_TYPE\"+i+\".value != \'02\' && document.form1.APPL_APPU_TYPE\"+j+\".value != \'02\' \")){	\n");
			sb.append("                     //if (eval(\"document.form1.APPL_PERNR\"+i+\".value == document.form1.APPL_PERNR\"+j+\".value \")){  								\n");
			sb.append("                         //alert(\"Settler’s redundancy input.\");                             							\n");
			sb.append("                         //return true;                                                           								\n");
			sb.append("                     //}                                                                          									\n");
			sb.append("                 }                                                                              									\n");
			sb.append("             }                                                                                  									\n");
			sb.append("         }                                                                                      									\n");
			sb.append("     }                                                                                     											\n");
			sb.append("     return false;                                                                              									\n");
			sb.append(" }                                                                                              									\n");
			sb.append(" </script>                                                                                      									\n");

            sb.append(" <div class=table>                                                                                     \n");
            sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"listTable\"> \n");
			sb.append("         <tr>                                                                                  									\n");
			sb.append("           <th class=\"th03\" width=\"120\">Approval Post</th>                                                 	\n");
			sb.append("           <th class=\"th03\">Name</th>  																				\n");
			sb.append("           <th class=\"th03\">Org.Unit Name</th>                                         							\n");
			sb.append("           <th class=\"th03\">Res.of Office</th>                                          								\n");
			sb.append("           <th class=\"th03\">Title of Level</th>                                          								\n");
			sb.append("           <th class=\"th03\">Tel.Number at Work</th>                                         						\n");
			sb.append("         </tr>                                                                                  									\n");

			for (int i = 0; i < AppLineData_vt.size(); i++) {
				AppLineData appLineData = (AppLineData) AppLineData_vt.get(i);
				DataUtil.fixNull(appLineData);

				String style = (appLineData.APPL_APPU_TYPE).equals("02") ? "input02" : "input03";

				sb.append(" <tr align=\"center\">                                                                              						\n");
				sb.append("   <td class=\"td04\">                                                                           						\n");
				sb.append("     <input type=\"text\" name=\"APPL_APPU_NAME" + i + "\" value=\""
										+ appLineData.APPL_APPU_NAME
										+ "\" size=\"15\" class=\"input02\" style=\"text-align:center\" readonly >    					\n");
				sb.append("   </td>																														\n");
				sb.append("   <td class=\"td09\" nowrap>                                                                             			\n");
				sb.append("     <input type=\"text\" name=\"APPL_ENAME" + i + "\" value=\""
										+ appLineData.APPL_ENAME
										+ "\" size=\"12\" class=\""
										+ style
										+ " \" readonly style=\"text-align:center;padding-top:2px;\">       								\n");
				//2015-11-05 pangxiaolin@v1.4 [C20151102_07776]  E-HR屏蔽审批人可选功能修改 begin
//				if ((appLineData.APPL_APPU_TYPE).equals("01")) {
//					sb.append("     <a href=\"javascript:;\" onClick=\"open_search(" + i + ");\">                                		\n");
//					sb.append("       <img src=\"" + WebUtil.ImageURL + "btn_serch.gif\" align=\"absmiddle\" border=\"0\" /></a>	\n");
//				}
//				2015-11-05 pangxiaolin@v1.4 [C20151102_07776]  E-HR屏蔽审批人可选功能修改 end
				sb.append("   </td>                                                                                                    					\n");
				sb.append(" <td class=\"td04\">                                                                                        		 		\n");
				sb.append("    <input type=\"text\" name=\"APPL_ORGTX" + i + "\" value=\""
										+ appLineData.APPL_ORGTX
										+ "\" size=\"30\" class=\"input02\" readonly style=\"text-align:center;padding-top:2px;\">	\n");
				sb.append("   </td>                                                                                                    	 				\n");
				sb.append("   <td class=\"td04\">                                                                                       			\n");
				sb.append("     <input type=\"text\" name=\"APPL_JIKKT" + i + "\" value=\""
										+ appLineData.APPL_JIKKT
										+ "\" size=\"14\" class=\"input02\" style=\"text-align:center;padding-top:2px;\" readonly >	\n");
				sb.append("   </td>                                                                                                     					\n");
				sb.append("   <td class=\"td04\">                                                                                         			\n");
				sb.append("     <input type=\"text\" name=\"APPL_JIKWT" + i + "\" value=\""
										+ appLineData.APPL_JIKWT
										+ "\" size=\"14\" class=\"input02\" style=\"text-align:center;padding-top:2px;\" readonly >	\n");
				sb.append("   </td>                                                                                                                 		\n");
				sb.append("   <td class=\"td04\">                                                                                          			\n");
				sb.append("     <input type=\"text\" name=\"APPL_TELNUMBER" + i + "\" value=\""
										+ appLineData.APPL_TELNUMBER
										+ "\" size=\"22\" class=\"input02\" style=\"text-align:center\" readonly >  						\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_UPMU_FLAG" + i + "\" value=\"" + UPMU_FLAG + "\" > 	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE" + i + "\" value=\"" + appLineData.APPL_APPU_TYPE + "\" >		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_TYPE" + i + "\" value=\"" + appLineData.APPL_APPR_TYPE + "\" >     	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN" + i + "\" value=\"" + appLineData.APPL_APPR_SEQN + "\" >   	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_PERNR" + i + "\" value=\"" + appLineData.APPL_PERNR + "\" >                 	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_OTYPE" + i + "\" value=\"" + appLineData.APPL_OTYPE + "\" >            		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_OBJID" + i + "\" value=\"" + appLineData.APPL_OBJID + "\" >                 		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_STEXT" + i + "\" value=\"" + appLineData.APPL_STEXT + "\" >             		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKWE" + i + "\" value=\"" + appLineData.APPL_JIKWE + "\" >                     \n");
				sb.append("     <input type=\"hidden\" name=\"APPL_JIKKB" + i + "\" value=\"" + appLineData.APPL_JIKKB + "\" >                      	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_DATE" + i + "\" value=\"" + appLineData.APPL_APPR_DATE + "\" >     	\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPR_STAT" + i + "\" value=\"" + appLineData.APPL_APPR_STAT + "\" >		\n");
				sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB" + i + "\" value=\"" + appLineData.APPL_PERNR + "\" >				\n");
				sb.append("   </td>                                                                                                                     	\n");
				sb.append(" </tr>                                                                                                                       	\n");
			}
			sb.append("        </table>                  																								\n");
			sb.append("      </div>                       																								\n");
			sb.append("  <!-- 결재자 입력 테이블 끝  --> 																							\n");
			sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\"" + AppLineData_vt.size() + "\">  					\n");

			return sb.toString();
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}


	/** [신규]GEHR
	 * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
	 *
	 * @param AppLineData_vt
	 *            java.util.Vector hris.common.AppLineData 결재정보
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */

	public static String returnHtml(Vector AppLineData_vt) throws GeneralException {

	try {
		StringBuffer sb = new StringBuffer();

		sb.append("	     <div class='table'>                                      \n");
        sb.append("	<table class='listTable' id='-approvalLine-table'>    \n");
        sb.append("	    <colgroup>                                        \n");
        sb.append("	        <col width='15%' />                           \n");
        sb.append("	        <col width='20%' />                           \n");
        sb.append("	        <col width='10%' />                           \n");
        sb.append("	        <col width='55%' />                           \n");
        sb.append("	    </colgroup>                                       \n");
        sb.append("	    <thead>                                           \n");
        sb.append("	    <tr>                                              \n");
        sb.append("	        <th>"+g.getMessage("MSG.APPROVAL.0012")+"</th>                                 \n");//<%--구분--%>
        sb.append("	        <th>"+g.getMessage("MSG.APPROVAL.0013")+"</th>                                 \n");//<%--성명--%>
        sb.append("	        <th>"+g.getMessage("MSG.APPROVAL.0014")+"</th>                                 \n");//<%--직위--%>
        sb.append("	        <th class='lastCol'>"+g.getMessage("MSG.APPROVAL.0015")+"</th>                 \n");//<%--부서--%>
        sb.append("	    </tr>                                             \n");
        sb.append("	    </thead>                                          \n");

		for (int i = 0; i < AppLineData_vt.size(); i++) {
			AppLineData AppLineData = (AppLineData) AppLineData_vt.get(i);
			DataUtil.fixNull(AppLineData);

			String APPL_APPR_STAT = "";
			if (AppLineData.APPL_APPR_STAT.equals("A")) {
				APPL_APPR_STAT = "Approved";
			} else if (AppLineData.APPL_APPR_STAT.equals("R")) {
				APPL_APPR_STAT = "Reject";
			} else {
				APPL_APPR_STAT = "Not Approved";
			}

            sb.append("<tr class='oddRow' >                                                                             																			\n");
            sb.append("    <td>"+AppLineData.APPL_APPU_NAME+"</td>                                                                                									\n");
            sb.append("    <td>                                                                                         																					\n");
            sb.append("        <input id='APPLINE_ENAME_" + i + "' data-idx='" + i + "'  name='APPLINE_ENAME'                           										\n");
			sb.append("			type='text' value='"+ AppLineData.APPL_ENAME+"' placeholder='"+ AppLineData.APPL_ENAME+"' readonly/>                 \n");
            sb.append("                                                                                                 																					\n");
            //[CSR ID:3438118] flexible time 시스템 요청 2017/09/05 eunha start
            //sb.append("            <a href='javascript:;' class='-search-decision unloading' data-idx='" + i + "'>                        															\n");
            sb.append("            <a href=\"javascript:;\"\"  onClick=\"changePop("+ i +")\";  id = '-search-decision_" + i + "'  class='-search-decision unloading'  data-idx='" + i + "' data-objid='"+ AppLineData.APPL_OBJID+"'>");
          //[CSR ID:3438118] flexible time 시스템 요청 2017/09/05 eunha end
            sb.append("				<img src='/web/images/sshr/ico_magnify.png' /></a>                                  																\n");
            sb.append("                                                                                                 																					\n");
            sb.append("        <input type='hidden' id='APPLINE_APPR_TYPE_" + i + "' name='APPLINE_APPR_TYPE' value='"+ AppLineData.APPL_APPR_TYPE+"' />     \n");
            sb.append("        <input type='hidden' id='APPLINE_APPU_TYPE_" + i + "' name='APPLINE_APPU_TYPE' value='"+ AppLineData.APPL_APPU_TYPE+"' />     \n");
            sb.append("        <input type='hidden' id='APPLINE_APPR_SEQN_" + i + "' name='APPLINE_APPR_SEQN' value='"+ AppLineData.APPL_APPR_SEQN+"' />     \n");
//            sb.append("        <input type='hidden' id='APPLINE_APPU_NUMB_" + i + "' name='APPLINE_APPU_NUMB' value='"+ AppLineData.APPL_APPU_NUMB+"'  \n");
			sb.append("        <input type='hidden' id='APPLINE_APPU_ENC_NUMB_" + i + "' name='APPLINE_APPU_ENC_NUMB' value='"+ AESgenerUtil.encryptAES(AppLineData.APPL_APPU_NUMB) +"'  \n");
			sb.append("				placeholder='결재자'/>                                                          																					\n");
            sb.append("        <input type='hidden' id='APPLINE_OTYPE_" + i + "' name='APPLINE_OTYPE' value='T' />              											\n");
            sb.append("        <input type='hidden' id='APPLINE_OBJID_" + i + "' name='APPLINE_OBJID' value='"+ AppLineData.APPL_OBJID+"' />       				\n");
            sb.append("    </td>                                                                                        																					\n");
          //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start
            if(isChangeGlobalJIKKT(AppLineData.APPL_BUKRS,  AppLineData.APPL_PERSG, AppLineData.APPL_PERSK, AppLineData.APPL_JIKWE, AppLineData.APPL_JIKKT, AppLineData.APPL_JIKCH)){
            	 sb.append("    <td id='-APPLINE-JIKWT-" + i + "' >"+ AppLineData.APPL_JIKKT+"</td>   	\n");
            } else{
            	 sb.append("    <td id='-APPLINE-JIKWT-" + i + "' >"+ AppLineData.APPL_JIKWT+"</td>    	\n");
            }
          //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end
            sb.append("    <td id='-APPLINE-ORGTX-" + i + "' class='lastCol align_left'>"+ AppLineData.APPL_ORGTX+"</td>                     							\n");
            sb.append("</tr>                                                                                            																					\n");
		}

        sb.append("	</table>                                          \n");
        sb.append("	</div>                                          \n");

		return sb.toString();
	} catch (Exception e) {
		throw new GeneralException(e);
	}
}

    /**
     * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
     * @param AppLineData_vt java.util.Vector hris.common.AppLineData 결재정보
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private static String returnHtml( Vector AppLineData_vt,String E_PERNR ) throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            sb.append(" <!-- 결재자 입력 테이블 시작-->                                                                \n");
            sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">               \n");
            sb.append(" <script language=\"javascript\">                                                               \n");
            sb.append(" function change_AppData( index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER ){                \n");
            sb.append("    eval(\"document.form1.APPL_PERNR\"+index+\".value = PERNR\");                               \n");
            sb.append("    eval(\"document.form1.APPL_APPU_NUMB\"+index+\".value = PERNR\");                           \n");
            sb.append("    eval(\"document.form1.APPL_ENAME\"+index+\".value = ENAME\");                               \n");
            sb.append("    eval(\"document.form1.APPL_ORGTX\"+index+\".value = ORGTX\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TITEL\"+index+\".value = TITEL\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TITL2\"+index+\".value = TITL2\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TELNUMBER\"+index+\".value = TELNUMBER\");                       \n");
            sb.append(" }                                                                                              \n");
            sb.append("  function open_search(index,pernr) {                                                                 \n");
            sb.append("      objid = eval(\"document.form1.APPL_OBJID\"+index+\".value\");                             \n");
            sb.append("      theURL = \""+WebUtil.JspURL+"common/AppLinePop.jsp?index=\"+index+\"&objid=\"+objid+\"&pernr=\"+pernr;      \n");
            sb.append("      window.open(theURL,\"essSearch\",\"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100\"); \n");
            sb.append("  }                                                                                             \n");
            sb.append(" function check_empNo(){                                                                        \n");
            sb.append("     var size = document.form1.app_size.value;                                                  \n");
            sb.append("     if( size == 0 ){                                                                           \n");
            sb.append("          alert(\"결재자 정보가 없습니다.\");                                                   \n");
            sb.append("          return true;                                                                          \n");
            sb.append("     }                                                                                          \n");
            sb.append("     for ( i = 0 ; i<size ; i++ ){                                                              \n");
            sb.append("         val = eval(\"document.form1.APPL_APPU_NUMB\"+i+\".value\");                            \n");
            sb.append("         if( val == \"\" || val == null || val == \"00000000\" ){                               \n");
            sb.append("          alert(\"결재자 이름을 입력하세요.\");                                                 \n");
            sb.append("             return true;                                                                       \n");
            sb.append("         }                                                                                      \n");
            sb.append("     }                                                                                          \n");
            sb.append("     for( i = 0; i < size; i++ ){                                                               \n");
            sb.append("         for( j = 0; j < size; j++){                                                            \n");
            sb.append("             if( i != j ){                                                                      \n");
            sb.append("                 if( eval(\"document.form1.APPL_APPU_TYPE\"+i+\".value != \'02\' && document.form1.APPL_APPU_TYPE\"+j+\".value != \'02\' \") ){   \n");
            sb.append("                     if( eval(\"document.form1.APPL_PERNR\"+i+\".value == document.form1.APPL_PERNR\"+j+\".value \") ){   \n");
            sb.append("                         alert(\"결재자가 중복 입력되었습니다.\");                              \n");
            sb.append("                         return true;                                                           \n");
            sb.append("                     }                                                                          \n");
            sb.append("                 }                                                                              \n");
            sb.append("             }                                                                                  \n");
            sb.append("         }                                                                                      \n");
            sb.append("     }                                                                                          \n");
            sb.append("     return false;                                                                              \n");
            sb.append(" }                                                                                              \n");
            sb.append(" </script>                                                                                      \n");
            sb.append(" <div class=table>                                                                                     \n");
            sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"listTable\"> \n");
            sb.append("         <tr>                                                                                   \n");
            sb.append("           <th class=\"th03\" width=\"100\">                                                    \n");
            sb.append("             <p><spring:message code='MSG.APPROVAL.0012' /><%--구분--%></p>                                                                 \n");
            sb.append("           </th>                                                                                \n");
            sb.append("           <th class=\"th03\" width=\"150\"><spring:message code='MSG.APPROVAL.0013' /><%--성명--%><font color=\"#006699\"><b>*</b></font></th>  \n");
            sb.append("           <th class=\"th03\" width=\"270\"><spring:message code='MSG.APPROVAL.0015' /><%--부서--%></th>                                         \n");
            sb.append("           <th class=\"th03\" width=\"100\">직 책</th>                                          \n");
            sb.append("           <th class=\"th03\" width=\"160\">연락처</th>                                         \n");
            sb.append("         </tr>                                                                                  \n");
            for( int i = 0; i < AppLineData_vt.size(); i++ ) {
                AppLineData appLineData = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( appLineData );
                String style = (appLineData.APPL_APPU_TYPE).equals("02") ? "input02" : "input03" ;

                sb.append(" <tr align=\"center\">                                                                                                                \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_APPU_NAME"+ i +"\" value=\""+ appLineData.APPL_APPU_NAME +"\" size=\"14\" class=\"input02\" style=\"text-align:center\" readonly >    \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td09\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_ENAME"+ i +"\" value=\""+ appLineData.APPL_ENAME +"\" size=\"12\" class=\""+ style +" \" readonly >       \n");
                sb.append("     <a href=\"javascript:;\" onClick=\"open_search("+ i +",'"+E_PERNR+"');\">                                                                      \n");

                if( appLineData.APPL_APPU_TYPE.equals("01") ){
                    sb.append("       <img src=\""+ WebUtil.ImageURL +"btn_serch.gif\" align=\"absmiddle\" border=\"0\"></a>          \n");
                }
                sb.append("                                                                                                                                      \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_ORGTX"+ i +"\" value=\""+ appLineData.APPL_ORGTX +"\" size=\"40\" class=\"input02\" readonly >  \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_TITL2"+ i +"\" value=\""+ appLineData.APPL_TITL2 +"\" size=\"14\" class=\"input02\" style=\"text-align:center\" readonly >  \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_TELNUMBER"+ i +"\"   value=\""+ appLineData.APPL_TELNUMBER +"\" size=\"22\" class=\"input02\" style=\"text-align:center\" readonly >  \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_UPMU_FLAG"+ i +"\" value=\""+ UPMU_FLAG +"\" >                                                \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE"+ i +"\" value=\""+ appLineData.APPL_APPU_TYPE +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPR_TYPE"+ i +"\" value=\""+ appLineData.APPL_APPR_TYPE +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN"+ i +"\" value=\""+ appLineData.APPL_APPR_SEQN +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_PERNR"+ i +"\"     value=\""+ appLineData.APPL_PERNR +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_OTYPE"+ i +"\"     value=\""+ appLineData.APPL_OTYPE +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_OBJID"+ i +"\"     value=\""+ appLineData.APPL_OBJID +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_STEXT"+ i +"\"     value=\""+ appLineData.APPL_STEXT +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_TITEL"+ i +"\"     value=\""+ appLineData.APPL_TITEL +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB"+ i +"\" value=\""+ appLineData.APPL_PERNR +"\" >                                   \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append(" </tr>                                                                                                                                \n");
                Logger.debug("@@@@@결재자정보:"+appLineData.APPL_ENAME+"("+appLineData.APPL_PERNR+")");
            }
            sb.append("        </table>                  \n");
            sb.append("        </div>                  \n");
            sb.append("  <!-- 결재자 입력 테이블 끝  --> \n");
            sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\""+ AppLineData_vt.size() +"\">  \n");

            return sb.toString();
        } catch( Exception e){
            throw new GeneralException(e);
        }
    }
    /**
     * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
     * @param AppLineData_vt java.util.Vector hris.common.AppLineData 결재정보
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private static String returnHtmlNot( Vector AppLineData_vt ) throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            sb.append(" <!-- 결재자 입력 테이블 시작-->                                                                \n");
            sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">               \n");
            sb.append(" <script language=\"javascript\">                                                               \n");
            sb.append(" function change_AppData( index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER ){                \n");
            sb.append("    eval(\"document.form1.APPL_PERNR\"+index+\".value = PERNR\");                               \n");
            sb.append("    eval(\"document.form1.APPL_APPU_NUMB\"+index+\".value = PERNR\");                           \n");
            sb.append("    eval(\"document.form1.APPL_ENAME\"+index+\".value = ENAME\");                               \n");
            sb.append("    eval(\"document.form1.APPL_ORGTX\"+index+\".value = ORGTX\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TITEL\"+index+\".value = TITEL\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TITL2\"+index+\".value = TITL2\");                               \n");
            sb.append("    eval(\"document.form1.APPL_TELNUMBER\"+index+\".value = TELNUMBER\");                       \n");
            sb.append(" }                                                                                              \n");
            sb.append("  function open_search(index) {                                                                 \n");
            sb.append("      objid = eval(\"document.form1.APPL_OBJID\"+index+\".value\");                             \n");
            sb.append("      theURL = \""+WebUtil.JspURL+"common/AppLinePop.jsp?index=\"+index+\"&objid=\"+objid;      \n");
            sb.append("      window.open(theURL,\"essSearch\",\"toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=537,height=365,left=100,top=100\"); \n");
            sb.append("  }                                                                                             \n");
            sb.append(" function check_empNo(){                                                                        \n");
            sb.append("     var size = document.form1.app_size.value;                                                  \n");
            sb.append("     if( size == 0 ){                                                                           \n");
            sb.append("          alert(\"결재자 정보가 없습니다.\");                                                   \n");
            sb.append("          return true;                                                                          \n");
            sb.append("     }                                                                                          \n");
            sb.append("     for ( i = 0 ; i<size ; i++ ){                                                              \n");
            sb.append("         val = eval(\"document.form1.APPL_APPU_NUMB\"+i+\".value\");                            \n");
            sb.append("         if( val == \"\" || val == null || val == \"00000000\" ){                               \n");
            sb.append("          alert(\"결재자 이름을 입력하세요.\");                                                 \n");
            sb.append("             return true;                                                                       \n");
            sb.append("         }                                                                                      \n");
            sb.append("     }                                                                                          \n");
            sb.append("     for( i = 0; i < size; i++ ){                                                               \n");
            sb.append("         for( j = 0; j < size; j++){                                                            \n");
            sb.append("             if( i != j ){                                                                      \n");
            sb.append("                 if( eval(\"document.form1.APPL_APPU_TYPE\"+i+\".value != \'02\' && document.form1.APPL_APPU_TYPE\"+j+\".value != \'02\' \") ){   \n");
            sb.append("                     if( eval(\"document.form1.APPL_PERNR\"+i+\".value == document.form1.APPL_PERNR\"+j+\".value \") ){   \n");
            sb.append("                         alert(\"결재자가 중복 입력되었습니다.\");                              \n");
            sb.append("                         return true;                                                           \n");
            sb.append("                     }                                                                          \n");
            sb.append("                 }                                                                              \n");
            sb.append("             }                                                                                  \n");
            sb.append("         }                                                                                      \n");
            sb.append("     }                                                                                          \n");
            sb.append("     return false;                                                                              \n");
            sb.append(" }                                                                                              \n");
            sb.append(" </script>                                                                                      \n");
            sb.append(" <div class=table>                                                                                     \n");
            sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"listTable\"> \n");
            sb.append("         <tr>                                                                                   \n");
            sb.append("           <th class=\"th03\" width=\"100\">                                                    \n");
            sb.append("             <p>결재자 구분</p>                                                                 \n");
            sb.append("           </th>                                                                                \n");
            sb.append("           <th class=\"th03\" width=\"150\">성 명&nbsp;<font color=\"#006699\"><b>*</b></font></th>  \n");
            sb.append("           <th class=\"th03\" width=\"270\">부서명</th>                                         \n");
            sb.append("           <th class=\"th03\" width=\"100\">직 책</th>                                          \n");
            sb.append("           <th class=\"th03\" width=\"160\">연락처</th>                                         \n");
            sb.append("         </tr>                                                                                  \n");
            for( int i = 0; i < AppLineData_vt.size(); i++ ) {
                AppLineData appLineData = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( appLineData );
                String style = (appLineData.APPL_APPU_TYPE).equals("02") ? "input02" : "input03" ;

                sb.append(" <tr align=\"center\">                                                                                                                \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_APPU_NAME"+ i +"\" value=\""+ appLineData.APPL_APPU_NAME +"\" size=\"14\" class=\"input02\" style=\"text-align:center\" readonly >    \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td09\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_ENAME"+ i +"\" value=\""+ appLineData.APPL_ENAME +"\" size=\"12\" class=\""+ style +" \" readonly >       \n");
                sb.append("     <a href=\"javascript:;\" onClick=\"open_search("+ i +");\">                                                                      \n");
                sb.append("                                                                                                                                      \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_ORGTX"+ i +"\" value=\""+ appLineData.APPL_ORGTX +"\" size=\"40\" class=\"input02\" readonly >  \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_TITL2"+ i +"\" value=\""+ appLineData.APPL_TITL2 +"\" size=\"14\" class=\"input02\" style=\"text-align:center\" readonly >  \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append("   <td class=\"td04\">                                                                                                                \n");
                sb.append("     <input type=\"text\" name=\"APPL_TELNUMBER"+ i +"\"   value=\""+ appLineData.APPL_TELNUMBER +"\" size=\"22\" class=\"input02\" style=\"text-align:center\" readonly >  \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_UPMU_FLAG"+ i +"\" value=\""+ UPMU_FLAG +"\" >                                                \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_TYPE"+ i +"\" value=\""+ appLineData.APPL_APPU_TYPE +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPR_TYPE"+ i +"\" value=\""+ appLineData.APPL_APPR_TYPE +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPR_SEQN"+ i +"\" value=\""+ appLineData.APPL_APPR_SEQN +"\" >                               \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_PERNR"+ i +"\"     value=\""+ appLineData.APPL_PERNR +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_OTYPE"+ i +"\"     value=\""+ appLineData.APPL_OTYPE +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_OBJID"+ i +"\"     value=\""+ appLineData.APPL_OBJID +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_STEXT"+ i +"\"     value=\""+ appLineData.APPL_STEXT +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_TITEL"+ i +"\"     value=\""+ appLineData.APPL_TITEL +"\" >                                   \n");
                sb.append("     <input type=\"hidden\" name=\"APPL_APPU_NUMB"+ i +"\" value=\""+ appLineData.APPL_PERNR +"\" >                                   \n");
                sb.append("   </td>                                                                                                                              \n");
                sb.append(" </tr>                                                                                                                                \n");
            }
            sb.append("        </table>                  \n");
            sb.append("      </div>                       \n");
            sb.append("  <!-- 결재자 입력 테이블 끝  --> \n");
            sb.append(" <input type=\"hidden\" name=\"RowCount\" value=\""+ AppLineData_vt.size() +"\">  \n");

            return sb.toString();
        } catch( Exception e){
            throw new GeneralException(e);
        }
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
    /**
     * 결재정보에 관한 항목을 HTML형식으로 변환해서 Return
     * @param AppLineData_vt java.util.Vector hris.common.AppLineData 결재정보
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private static String returnOrgDetailHtml( Vector AppLineData_vt ) throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            sb.append("<input type=\"hidden\" name=\"app_size\" value=\"" + AppLineData_vt.size() + "\">  \n");
            sb.append(" <!-- 결재자 조회 테이블 시작-->                                                   \n");
            sb.append(" <div class=table>                                                                                     \n");
            sb.append("       <table width=\"780\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" class=\"listTable\"> \n");
            sb.append("         <tr>                                                                      \n");
            sb.append("           <th class=\"th03\" width=\"100\">                                       \n");
            sb.append("             <p>결재자 구분</p>                                                    \n");
            sb.append("           </th>                                                                   \n");
            sb.append("           <th class=\"th03\" width=\"90\">성 명</th>                             \n");
            sb.append("           <th class=\"th03\" width=\"200\">부서명</th>                            \n");
            sb.append("           <th class=\"th03\" width=\"80\">직 책</th>                              \n");
            sb.append("           <th class=\"th03\" width=\"90\">승인일</th>                             \n");
            sb.append("           <th class=\"th03\" width=\"80\">상 태</th>                              \n");
            sb.append("           <th class=\"th03\" width=\"140\">연락처</th>                            \n");
            sb.append("         </tr>                                                                     \n");
            for( int i = 0; i < AppLineData_vt.size(); i++ ) {
                AppLineData appLineData = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( appLineData );
                String APPL_APPR_DATA = appLineData.APPL_APPR_DATE.equals("") ? "" : appLineData.APPL_APPR_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(appLineData.APPL_APPR_DATE, ".");
                String APPL_APPR_STAT = "";
                if (appLineData.APPL_APPR_STAT.equals("A")) {
                    APPL_APPR_STAT ="승인";
                } else if (appLineData.APPL_APPR_STAT.equals("R")) {
                    APPL_APPR_STAT ="반려";
                } else {
                    APPL_APPR_STAT ="미결";
                }

                sb.append(" <tr align=\"center\">                                                                                                                       \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(appLineData.APPL_APPU_NAME+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(appLineData.APPL_ENAME+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(appLineData.APPL_ORGTX+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(appLineData.APPL_TITL2+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(APPL_APPR_DATA+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(APPL_APPR_STAT+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append("   <td class=\"td04\">                                                                                                                       \n");
                sb.append(appLineData.APPL_TELNUMBER+"\n");
                sb.append("   </td>                                                                                                                                     \n");
                sb.append(" </tr>                                                                                                                                       \n");
            }

            sb.append("       </table>                  \n");
            sb.append("     </div>                       \n");
            sb.append(" <!-- 결재자 조회 테이블 시작--> \n");
            sb.append(" <input type=\"hidden\" name=\"DRowCount\" value=\""+ AppLineData_vt.size() +"\">  \n");
            sb.append("");

            return sb.toString();
        } catch( Exception e){
            throw new GeneralException(e);
        }
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
	/**
	 * @param entity
	 * @param string
	 * @param string2
	 */
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

/*[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림
	사원그룹 : A Expatriate		Field Persg
	사원하위그룹 : 01 Expatriate_KR		Field Persk
	Title of Level 직위 : 4090 주임		Field JIKWE
	Level 직위 : 4110 L3	 	Field JIKCH
	Res. Of office 직책 		Field JIKKB*/
    public static boolean  isChangeGlobalJIKKT (String BUKRS, String PERSG, String PERSK, String JIKWE, String  JIKKT, String JIKCH) {
// @PJ.광정우 법인(G570)  Rollout 2018-03-19 begin
// 2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout
// 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
    	if(Arrays.asList("G100","G110","G120","G150","G170" ,"G180","G220","G240","G250","G280" ,"G360","G370","G450","G460","G500","G570","G610","G620").contains(BUKRS)
                && PERSG.equals("A") && PERSK.equals("01") && JIKWE.equals("4090") && JIKCH.equals("4110")  && !StringUtils.isEmpty(JIKKT) ){
    		return true;
    	}
        return false;
    }
}
//@PJ.광정우 법인(G570)  Rollout 2018-03-19 end
