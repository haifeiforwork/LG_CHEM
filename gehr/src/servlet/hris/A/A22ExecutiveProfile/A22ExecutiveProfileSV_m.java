/**
 * A22ExecutiveProfileSV_m
 * 임원 profile 불러오는 SV
 *
 *
 * @author  이지은 2016-05-30
 * @version 1.0 [CSR ID:3089281] 임원 1Page 프로파일 시스템 개발 요청의 건.
 * 2017/09/08  [CSR ID:3460886] 임원 프로파일 시스템 수정 요청의 건.
 * 2017/10/19   [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
 */
package servlet.hris.A.A22ExecutiveProfile;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A22resultOfProfileData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.A.rfc.A22resultOfProfileRFC;
import hris.C.C03LearnDetailData;
import hris.C.db.C03LearnDetailDB;
import hris.C.db.C03MapPernrData;
import hris.N.WebAccessLog;
import hris.common.WebUserData;
import hris.common.rfc.GetPhotoURLRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.C.C03LearnDetailSV;

import java.util.Map;
import java.util.Vector;

public class A22ExecutiveProfileSV_m  extends EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";
            String jobid2 = "";
            String licn_code = "";

            WebUserData user_m = WebUtil.getSessionMSSUser(req);



//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }


            jobid2     = box.get("jobid2");

            if( jobid2.equals("") ){
                jobid2 = "first";
            }
            Logger.debug( "[jobid2] = "+jobid2);

            //String imgUrl ="";
            GetPhotoURLRFC      photofunc = null;  // 사진
            A01SelfDetailRFC    selffunc  = null;  // 개인사항
//            A08LicenseDetailRFC licenfunc = null;  // 자격사항
            A02SchoolDetailRFC  scholfunc = null;  // 학력사항
            A04FamilyDetailRFC  familfunc = null;  // 가족사항
            Vector a01SelfDetailData_vt = new Vector();//개인사항
            Vector a22StrengthData_vt  = new Vector();// 성과
            Vector a22LeadershipData_vt  = new Vector();// 리더십
            Vector a22resultOfThreeYear_vt = new Vector();// 3개년 평가
            Vector a22busi_vt   = new Vector();
            Vector a22punish_vt    = new Vector();
            Vector a22edu_vt       = new Vector();
            Vector a22role_vt = new Vector();
            Vector a22career_vt = new Vector();
            Vector a22school_vt = new Vector();
            Vector a22language_vt = new Vector();
            Vector a22Info_vt = new Vector();


            /*******************
             * 웹로그 메뉴 코드명
             *******************/
            String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
            if(sMenuCode.equals("")){
            	sMenuCode = "M120";//임원 profile 메뉴코드
            }

            if ( user_m != null ) {

                // 사진링크
                photofunc = new GetPhotoURLRFC();
                //imgUrl = photofunc.getPhotoURL( user_m.empNo );

                // A01SelfDetailRFC 개인인적사항 조회
                selffunc = new A01SelfDetailRFC();
                a01SelfDetailData_vt = selffunc.getPersInfo(user_m.empNo, user.area.getMolga(), "");
                Logger.debug.println(this, "a01SelfDetailData_vt : "+ a01SelfDetailData_vt.toString());

                //성과/리더십
                A22resultOfProfileRFC swfunc = new A22resultOfProfileRFC();
                Map<String, Vector> resultMap =  swfunc.getProfile(user_m.empNo);

                a22StrengthData_vt = resultMap.get("getPersInfoS");
                a22LeadershipData_vt = resultMap.get("getPersInfoW");
                //Logger.debug("!!!!!!!@@@@@@@@@@@@@@@ " +a22StrengthData_vt.get(1));
                //Logger.debug("!!!!!!!@@@@@@@@@@@@@@@ " +a22WeaknessData_vt.get(1));

                //3개년 평가
                a22resultOfThreeYear_vt = resultMap.get("getResult3Year");

                //사업가 후보
                a22busi_vt = resultMap.get("getBusiness");

                //징계
                a22punish_vt = resultMap.get("getPunish");

                //주요 교육이력
                a22edu_vt = resultMap.get("getEdu");

                /* [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청 start
                 * 1) 사업가 후보 정보 조회
   						-  핵심인재관리 마스터 내 사업부장과정 이수, 예비경영자 과정 추천 내역
				   2) 교육이력 조회
   						- 임원 교육과정 이력 중 가장 최근 1건만 조회
				   3) 결과 조회 기준
     					- 1) + 2) 전체 기준 최신 일정 순으로 정렬 (시작일 DESCENDING)
     					- 교육명('YY) 형태로 조회, 여러건일 경우 ',' 로 구분
           				( ex:EnDP 시장선도와 미래준비('16) , 예비경영자교육 추천인원('04)  )
           	   */
                C03LearnDetailDB c03LearnDetailDB=   new C03LearnDetailDB();
                C03MapPernrData c03MapPernrData = C03LearnDetailSV.getMapPernr(g,  user_m.empNo,  "");
                Vector<C03LearnDetailData> resultList = c03LearnDetailDB.getImwonEduList(c03MapPernrData.PERNR);

                if(Utils.getSize(resultList)>0){
                	A22resultOfProfileData a22resultOfProfileData = new A22resultOfProfileData();
                	C03LearnDetailData c03LearnDetailData = Utils.indexOf(resultList, 0, C03LearnDetailData.class);
                	a22resultOfProfileData.CRESULT  = c03LearnDetailData.DVSTX+"('"+c03LearnDetailData.BEGDA.substring(2,4)+")";
                	a22resultOfProfileData.BEGDA = c03LearnDetailData.BEGDA;
                	a22edu_vt.add(a22resultOfProfileData);
                	a22edu_vt = SortUtil.sort( a22edu_vt, "BEGDA", "desc" ); //Vector Sort
                }
               //[CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청 end
                //역할급
                a22role_vt = resultMap.get("getRole");

                //직위
                //a22career_vt = resultMap.get("getCareer");

                //학력
                a22school_vt = resultMap.get("getSchool");

              	//어학
                a22language_vt = resultMap.get("getLang");

              	//인사기본정보
                a22Info_vt = resultMap.get("getInfo");

                String birthday = "";
                String geunsok = "";
                Double imwonAge = 0.0;
                Double geunsokAge = 0.0;
                A22resultOfProfileData dataInfo = new A22resultOfProfileData();
                if(a22Info_vt.size() != 0){
                    Logger.debug(a22Info_vt.get(0).getClass());
                	dataInfo = (A22resultOfProfileData)a22Info_vt.get(0);
                	birthday = dataInfo.GBDAT.replace("-", "");
                	geunsok = dataInfo.DAT01.replace("-", "");

                	imwonAge = getAgeFromBirthday(birthday.substring(0, 4),birthday.substring(4,6));
                	geunsokAge = getAgeFromBirthday(geunsok.substring(0, 4),geunsok.substring(4,6));
                }

                //req.setAttribute("imgUrl", imgUrl);
                req.setAttribute("a01SelfDetailData_vt", a01SelfDetailData_vt);
                req.setAttribute("a22StrengthData_vt", a22StrengthData_vt);
            	req.setAttribute("a22LeadershipData_vt", a22LeadershipData_vt);
            	req.setAttribute("a22busi_vt", a22busi_vt);
            	req.setAttribute("a22punish_vt", a22punish_vt);
            	req.setAttribute("a22edu_vt", a22edu_vt);
            	req.setAttribute("a22role_vt", a22role_vt);
            	req.setAttribute("a22career_vt", a22career_vt);
            	req.setAttribute("a22school_vt", a22school_vt);
            	req.setAttribute("a22language_vt", a22language_vt);
            	req.setAttribute("a22Info_vt", a22Info_vt);
            	req.setAttribute("imwonAge", imwonAge.toString());
            	req.setAttribute("geunsokAge", geunsokAge.toString());
            	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);

                req.setAttribute("actionList", resultMap.get("getAction"));
                req.setAttribute("sPlanList", resultMap.get("getSPlan"));
                req.setAttribute("sPlanListPost", resultMap.get("getSPlanPost"));//[CSR ID:3460886]

                if( jobid2.equals("first") ) {


                	dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfile_m.jsp";
                }else if(jobid2.equals("print") ){
                	/**
                	 * 웹로그 추가 2015-06-19
                	 * EADMIN 와 EMANAG로 시작하는 사용자는 제외 한다.
                	 * 개발자,운영자,관리자는 웹로그 추가 제외임
                	 * MSS 부서개인정보를 조회하는 메뉴에 모두 추가함.
                	 *  session.setAttribute("remoteIP",remoteIP); IP추가 작업
                	 *
                	 */

                	if(!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")){
                        (new WebAccessLog()).setAccessLog(sMenuCode, user.empNo, user_m.empNo, user.remoteIP);
                	}
                	dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfilePrint.jsp";
                }else if(jobid2.equals("leader") ){//성과 리더십
                	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);
                	dest = WebUtil.JspURL+"N/orgstats/profilechart9.jsp";
                }else if(jobid2.equals("mission") ){//Mission
                	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);
                	dest = WebUtil.JspURL+"N/orgstats/profilechart10.jsp";
                } else {
                    throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                }
            } else {
                //req.setAttribute("imgUrl", imgUrl);
                dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfile_m.jsp";
            }

            Logger.debug( " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
        }
	}


	//나이 계산하기
	public static double getAgeFromBirthday(String yyyy,String mm) {
		Double year = Double.parseDouble(DataUtil.getCurrentYear())- Integer.parseInt(yyyy);
		Double month = Double.parseDouble(DataUtil.getCurrentMonth()) - Integer.parseInt(mm);
		Double result = 0.00;
		Double calcMonth = 0.00;
		if(month != 0.0){
			calcMonth = month/12;
			calcMonth = DataUtil.banolim(calcMonth,2);
		}
		result = year + calcMonth;
	    return result;
	}







}
