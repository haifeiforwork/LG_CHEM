/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetailSV.java                                    */
/*   Description  : 개인의 휴가현황 정보를 jsp로 넘겨주는 class                 		*/
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-12-21  @v1.1 lsa C2005122101000000223 2005년도 사용일수가 안나타남 */
/*                  2006-01-17  @v1.2 lsa 사용일수 로직 오류수정                		*/
/*   	          : [CSR ID:2797167] 휴가실적 출력 용 화면 추가요청 				*/
/*                     //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
/*                : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/********************************************************************************/
package servlet.hris.D.D04Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03VacationUsedData;
import hris.D.D03Vocation.rfc.D03GetWorkdayOfficeRFC;
import hris.D.D03Vocation.rfc.D03VacationUsedRFC;
import hris.D.rfc.D04VocationDetailOfficeRFC;
import hris.common.EmpGubunData;
import hris.common.WebUserData;
import hris.common.rfc.GetEmpGubunRFC;

/**
 * D04VocationDetailSV.java
 * 개인의 휴가현황 정보를 jsp로 넘겨주는 class
 * 개인의 휴가현황 정보를 가져오는 D04VocationDetailRFC를 호출하여 D04VocationDetail.jsp로 개인의 휴가현황 정보를 넘겨준다.
 *
 * @author chldudgh
 * @version 1.0, 2002/01/21
 * 2015-12-23 [CSR ID:2945528] 휴가실적정보 화면 수정
 */
public class D04VocationDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
           WebUserData user   = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            /**         * Start: 국가별 분기처리
             * //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  */
            String fdUrl = ".";

           if (user.area.equals(Area.KR) ) {
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE) || user.area.equals(Area.US)|| user.area.equals(Area.MX)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   fdUrl = "hris.D.D04Vocation.D04VocationDetailEurpSV";
			} else{
				fdUrl = "hris.D.D04Vocation.D04VocationDetailGlobalSV";
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: 국가별 분기처리             */

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            // 사원근무 구분값
            String EMPGUB = "";
            GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
            Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(user.empNo);
            if(empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
            req.setAttribute("EMPGUB", EMPGUB);

            if( jobid.equals("first") ) {

                String year  = DataUtil.getCurrentDate().substring(0,4);
                Logger.debug.println(this, "현재날짜 = "+year);

                //[CSR ID:2945528] 휴가실적정보 화면 수정
                String monthDay = DataUtil.getCurrentDate().substring(4,8);
                Logger.debug.println(this, "현재 월일 = "+monthDay);
                if(Integer.parseInt(monthDay) >= Integer.parseInt("1221")){
                	year = DataUtil.getAfterYear(DataUtil.getCurrentDate(), 1).substring(0,4);
                	Logger.debug.println(this, "내년년도 = "+year);
                }

                D03VacationUsedRFC   rfcVacation         = new D03VacationUsedRFC();
                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();
                String               E_ABRTG             = rfcVacation.getE_ABRTG(user.empNo);

                Vector d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user.empNo );
                for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                    D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                    d03VacationUsedData = data;
                }
                
                Vector ret = null;
                Object D03GetWorkdayData_vt = null;
                
                String NON_ABSENCE = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();
                
            	D04VocationDetailOfficeRFC rfc = new D04VocationDetailOfficeRFC();
            	ret = rfc.getVocationDetail(user.empNo, year);
            	
            	D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
            	if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                    D03GetWorkdayData_vt = func.getWorkday(user.empNo, year+"1220", "C");
                else
                    D03GetWorkdayData_vt = func.getWorkday(user.empNo, DataUtil.getCurrentDate(), "C");
                
                NON_ABSENCE = (String) ret.get(0);
                LONG_SERVICE = (String) ret.get(1);
                FLEXIBLE = (String) ret.get(2);
                d04VocationDetail1Data_vt = (Vector) ret.get(3);
                d04VocationDetail2Data_vt = (Vector) ret.get(4);
                d04VocationDetail3Data_vt = (Vector) ret.get(6);
                d04VocationDetail4Data_vt = (Vector) ret.get(7);
                E_COMPTIME = (String) ret.get(8);
            	d04VocationDetail5Data_vt = (Vector) ret.get(9);
            	d04VocationDetail6Data_vt = (Vector) ret.get(10);

                if( d04VocationDetail1Data_vt.size() == 0 && d04VocationDetail2Data_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {
                    ////////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "휴가발생내역 : "+ d04VocationDetail1Data_vt.toString());
                    Logger.debug.println(this, "휴가사용내역 : "+ d04VocationDetail2Data_vt.toString());
                    Logger.debug.println(this, "사전부여휴가내역 : "+ d04VocationDetail3Data_vt.toString());
                    Logger.debug.println(this, "개근연차 : "+ NON_ABSENCE.toString());
                    Logger.debug.println(this, "근속연차 : "+ LONG_SERVICE.toString());
                    Logger.debug.println(this, "하계휴가 일수 : " + E_ABRTG.toString());
                    Logger.debug.println(this, "하계휴가내역 : "+ d03VacationUsedData_vt.toString());
                    Logger.debug.println(this, "유연휴가 : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 유연휴가제
                    Logger.debug.println(this, "보상휴가 : "+ E_COMPTIME.toString());
                    Logger.debug.println(this, "보상휴가발생내역 : "+ d04VocationDetail5Data_vt.toString());
                    Logger.debug.println(this, "보상휴가사용내역 : "+ d04VocationDetail6Data_vt.toString());


                    req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                    req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                    req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                    req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                    req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                    req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                    req.setAttribute("year", year);
                    req.setAttribute("E_ABRTG", E_ABRTG);
                    req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                    req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                    req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 유연휴가제
                    req.setAttribute("E_COMPTIME", E_COMPTIME);
                    req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                    req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);
                    ////////////////////////////////////////////////////////////////////////////

                    dest = WebUtil.JspURL+"D/D04VocationDetail.jsp";
                }
            } else if(jobid.equals("search")){

                String year  = box.get("year");
                Logger.debug.println(this, "선택한날짜 : "+ year);
                D03VacationUsedRFC   rfcVacation         = new D03VacationUsedRFC();
                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();
                String               E_ABRTG             = rfcVacation.getE_ABRTG(user.empNo);
                Vector d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user.empNo );
                for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                    D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                    d03VacationUsedData = data;
                }
                
                Vector ret = null;
                Object D03GetWorkdayData_vt = null;
                String curr_year = DataUtil.getCurrentYear();
                
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";//@rdcamel 2016.12.15 유연휴가제 추가
                Vector d04VocationDetail1Data_vt = new Vector();  // 휴가발생내역
                Vector d04VocationDetail2Data_vt = new Vector();  // 휴가사용내역
                Vector d04VocationDetail3Data_vt = new Vector();  // 사전부여휴가내역
                Vector d04VocationDetail4Data_vt = new Vector();  // 선택적보상휴가내역
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();
                
            	D04VocationDetailOfficeRFC rfc = new D04VocationDetailOfficeRFC();
            	ret = rfc.getVocationDetail(user.empNo, year);
            	
            	D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
            	
            	if ( year.equals( curr_year) ) {
                    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                        D03GetWorkdayData_vt = func.getWorkday( user.empNo, year+"1220", "C" );
                    else
                        D03GetWorkdayData_vt = func.getWorkday( user.empNo, DataUtil.getCurrentDate(), "C" );
                } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                  D03GetWorkdayData_vt = func.getWorkday( user.empNo, DataUtil.getCurrentDate(), "C");
                } else {
                  D03GetWorkdayData_vt = func.getWorkday( user.empNo, year+"1220", "C" );
                }
                
                NON_ABSENCE = (String) ret.get(0);
                LONG_SERVICE = (String) ret.get(1);
                FLEXIBLE = (String) ret.get(2);
                d04VocationDetail1Data_vt = (Vector) ret.get(3);
                d04VocationDetail2Data_vt = (Vector) ret.get(4);
                d04VocationDetail3Data_vt = (Vector) ret.get(6);
                d04VocationDetail4Data_vt = (Vector) ret.get(7);
                E_COMPTIME = (String) ret.get(8);
            	d04VocationDetail5Data_vt = (Vector) ret.get(9);
            	d04VocationDetail6Data_vt = (Vector) ret.get(10);

                if( d04VocationDetail1Data_vt.size() == 0 && d04VocationDetail2Data_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {
                    ////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "휴가발생내역 : "+ d04VocationDetail1Data_vt.toString());
                    Logger.debug.println(this, "휴가사용내역 : "+ d04VocationDetail2Data_vt.toString());
                    Logger.debug.println(this, "사전부여휴가내역 : "+ d04VocationDetail3Data_vt.toString());
                    Logger.debug.println(this, "개근연차 : "+ NON_ABSENCE.toString());
                    Logger.debug.println(this, "근속연차 : "+ LONG_SERVICE.toString());
                    Logger.debug.println(this, "하계휴가 일수 : " + E_ABRTG.toString());
                    Logger.debug.println(this, "하계휴가내역 : "+ d03VacationUsedData_vt.toString());
                    Logger.debug.println(this, "유연휴가 : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 유연휴가제
                    Logger.debug.println(this, "보상휴가 : "+ E_COMPTIME.toString());
                    Logger.debug.println(this, "보상휴가발생내역 : "+ d04VocationDetail5Data_vt.toString());
                    Logger.debug.println(this, "보상휴가사용내역 : "+ d04VocationDetail6Data_vt.toString());

                    req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                    req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                    req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                    req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                    req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                    req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                    req.setAttribute("year", year);
                    req.setAttribute("E_ABRTG", E_ABRTG);
                    req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                    req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                    req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 유연휴가제
                    req.setAttribute("E_COMPTIME", E_COMPTIME);
                    req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                    req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);
                    ////////////////////////////////////////////////////////////////////////

                    dest = WebUtil.JspURL+"D/D04VocationDetail.jsp?jobid=search";
                }
//              [CSR ID:2797167]휴가명세표 출력팝업 추가 start
            }else if(jobid.equals("kubya_1")){
                String year   = box.get("year");

//
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D04Vocation.D04VocationDetailSV?jobid=kubya&year="+year);  // 5월 21일 순번 추가
                dest = WebUtil.JspURL+"common/printFrame.jsp";
     //           Logger.debug.println(this, WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5월 21일 순번 추가.
            }else if(jobid.equals("kubya")){
            	String year  = box.get("year");
                Logger.debug.println(this, "선택한날짜 : "+ year);
                D03VacationUsedRFC   rfcVacation         = new D03VacationUsedRFC();
                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();
                String               E_ABRTG             = rfcVacation.getE_ABRTG(user.empNo);
                Vector d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user.empNo );
                for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                    D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                    d03VacationUsedData = data;
                }
                
                Vector ret = null;
                Object D03GetWorkdayData_vt = null;
                String curr_year = DataUtil.getCurrentYear();
                
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";//@rdcamel 2016.12.15 유연휴가제 추가
                Vector d04VocationDetail1Data_vt = new Vector();  // 휴가발생내역
                Vector d04VocationDetail2Data_vt = new Vector();  // 휴가사용내역
                Vector d04VocationDetail3Data_vt = new Vector();  // 사전부여휴가내역
                Vector d04VocationDetail4Data_vt = new Vector();  // 선택적보상휴가내역
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();
                
            	D04VocationDetailOfficeRFC rfc = new D04VocationDetailOfficeRFC();
            	ret = rfc.getVocationDetail(user.empNo, year);
            	
            	D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
            	
            	if ( year.equals( curr_year) ) {
                    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                        D03GetWorkdayData_vt = func.getWorkday( user.empNo, year+"1220", "C" );
                    else
                        D03GetWorkdayData_vt = func.getWorkday( user.empNo, DataUtil.getCurrentDate(), "C" );
                } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                  D03GetWorkdayData_vt = func.getWorkday( user.empNo, DataUtil.getCurrentDate(), "C");
                } else {
                  D03GetWorkdayData_vt = func.getWorkday( user.empNo, year+"1220", "C" );
                }
                
                NON_ABSENCE = (String) ret.get(0);
                LONG_SERVICE = (String) ret.get(1);
                FLEXIBLE = (String) ret.get(2);
                d04VocationDetail1Data_vt = (Vector) ret.get(3);
                d04VocationDetail2Data_vt = (Vector) ret.get(4);
                d04VocationDetail3Data_vt = (Vector) ret.get(6);
                d04VocationDetail4Data_vt = (Vector) ret.get(7);
                E_COMPTIME = (String) ret.get(8);
            	d04VocationDetail5Data_vt = (Vector) ret.get(9);
            	d04VocationDetail6Data_vt = (Vector) ret.get(10);

                if( d04VocationDetail1Data_vt.size() == 0 && d04VocationDetail2Data_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {
                    ////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "휴가발생내역 : "+ d04VocationDetail1Data_vt.toString());
                    Logger.debug.println(this, "휴가사용내역 : "+ d04VocationDetail2Data_vt.toString());
                    Logger.debug.println(this, "사전부여휴가내역 : "+ d04VocationDetail3Data_vt.toString());
                    Logger.debug.println(this, "개근연차 : "+ NON_ABSENCE.toString());
                    Logger.debug.println(this, "근속연차 : "+ LONG_SERVICE.toString());
                    Logger.debug.println(this, "하계휴가 일수 : " + E_ABRTG.toString());
                    Logger.debug.println(this, "하계휴가내역 : "+ d03VacationUsedData_vt.toString());
                    Logger.debug.println(this, "유연휴가 : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 유연휴가
                    Logger.debug.println(this, "보상휴가 : "+ E_COMPTIME.toString());
                    Logger.debug.println(this, "보상휴가발생내역 : "+ d04VocationDetail5Data_vt.toString());
                    Logger.debug.println(this, "보상휴가사용내역 : "+ d04VocationDetail6Data_vt.toString());

                    req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                    req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                    req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                    req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                    req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                    req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                    req.setAttribute("year", year);
                    req.setAttribute("E_ABRTG", E_ABRTG);
                    req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                    req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                    req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 유연휴가
                    req.setAttribute("E_COMPTIME", E_COMPTIME);
                    req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                    req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);
                    ////////////////////////////////////////////////////////////////////////

                    dest = WebUtil.JspURL+"D/D04VocationDetail_print.jsp?jobid=search";
          }
            } Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        }catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}