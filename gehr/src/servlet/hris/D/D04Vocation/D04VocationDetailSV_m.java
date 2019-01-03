/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetailSV_m                                       */
/*   Description  : 개인의 휴가현황 정보를 jsp로 넘겨주는 class                 		*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  chldudgh                                        */
/*   Update       : 2005-01-24  윤정현                                          		*/
/*                : 2005-12-21  @v1.1 lsa C2005122101000000223 2005년도 사용일수가 안나타남 */
/*   	          : [CSR ID:2797167] 휴가실적 출력 용 화면 추가요청					*/
/*                : 2015-12-23 [CSR ID:2945528] 휴가실적정보 화면 수정 			*/
/*                : 2018-07-24 성환희 [Worktime52] 보상휴가 추가의 건 				*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D04Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

public class D04VocationDetailSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest = "";

            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if(!checkAuthorization(req, res)) return;

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }
            
            // 사원근무 구분값
            String EMPGUB = "";
            GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
            Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(user_m.empNo);
            if(empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
            req.setAttribute("EMPGUB", EMPGUB);
            
            if( jobid_m.equals("first") ) {

                String year  = DataUtil.getCurrentDate().substring(0,4);
                Logger.debug.println(this, "현재날짜 = "+year);

                // [CSR ID:2945528] 휴가실적정보 화면 수정
                String monthDay = DataUtil.getCurrentDate().substring(4,8);
                Logger.debug.println(this, "현재 월일 = "+monthDay);
                if(Integer.parseInt(monthDay) >= Integer.parseInt("1221")){
                	year = DataUtil.getAfterYear(DataUtil.getCurrentDate(), 1).substring(0,4);
                	Logger.debug.println(this, "내년년도 = "+year);
                }

                D04VocationDetailOfficeRFC rfc = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   rfcVacation = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();
                D03VacationUsedData  data                = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt      = new Object();
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String E_ABRTG      = "";
                String FLEXIBLE ="";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );

                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// 개근연차계
                    LONG_SERVICE = (String) ret.get(1);		// 근속년차계
                    FLEXIBLE = (String) ret.get(2);			// 유연휴가계
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// 휴가발생
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// 휴가사용
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// 휴가발생-사전부여
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// 휴가발생-선택적보상휴가
                    E_COMPTIME = (String) ret.get(8);		// 보상휴가계
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// 휴가발생-보상휴가
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// 휴가사용-보상휴가
                    
                    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                        D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    else
                        D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );

                } // if ( user_m != null ) end
                
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

                dest = WebUtil.JspURL+"D/D04VocationDetail_m.jsp";

            }else if(jobid_m.equals("search")){

                String year  = box.get("year");
                Logger.debug.println(this, "선택한날짜 : "+ year);
                D04VocationDetailOfficeRFC rfc           = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   	   rfcVacation   = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func          = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt = new Object();
                String E_ABRTG ="";
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );
                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// 개근연차계
                    LONG_SERVICE = (String) ret.get(1);		// 근속년차계
                    FLEXIBLE = (String) ret.get(2);			// 유연휴가계
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// 휴가발생
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// 휴가사용
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// 휴가발생-사전부여
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// 휴가발생-선택적보상휴가
                    E_COMPTIME = (String) ret.get(8);		// 보상휴가계
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// 휴가발생-보상휴가
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// 휴가사용-보상휴가

                    // 2004.09.08 추가 수정 ///////////////////////////////////////////////////////////
                    String curr_year = DataUtil.getCurrentYear();

                    if ( year.equals( curr_year) ) {  //@v1.2
                        if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                        else
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );
                    } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C");
                    } else {
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    }
                    // 2004.09.08 추가 수정 ///////////////////////////////////////////////////////////

                } // if ( user_m != null ) end

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

                dest = WebUtil.JspURL+"D/D04VocationDetail_m.jsp?jobid_m=search";

//             [CSR ID:2797167] 휴가명세표 출력팝업 추가 start
            }else if(jobid_m.equals("kubya_1")){
                String year   = box.get("year");
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D04Vocation.D04VocationDetailSV_m?jobid_m=kubya&year="+year);  // 5월 21일 순번 추가
                dest = WebUtil.JspURL+"common/printFrame.jsp";

            }else if(jobid_m.equals("kubya")){

                String year  = box.get("year");
                Logger.debug.println(this, "선택한날짜 : "+ year);
                D04VocationDetailOfficeRFC rfc                 = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   	   rfcVacation         = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func                = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt = new Object();
                String E_ABRTG ="";
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );
                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// 개근연차계
                    LONG_SERVICE = (String) ret.get(1);		// 근속년차계
                    FLEXIBLE = (String) ret.get(2);			// 유연휴가계
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// 휴가발생
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// 휴가사용
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// 휴가발생-사전부여
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// 휴가발생-선택적보상휴가
                    E_COMPTIME = (String) ret.get(8);		// 보상휴가계
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// 휴가발생-보상휴가
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// 휴가사용-보상휴가
                	
                    // 2004.09.08 추가 수정 ///////////////////////////////////////////////////////////
                    String curr_year = DataUtil.getCurrentYear();

                    if ( year.equals( curr_year) ) {  //@v1.2
                        if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                        else
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );
                    } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C");
                    } else {
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    }
                    // 2004.09.08 추가 수정 ///////////////////////////////////////////////////////////

                } // if ( user_m != null ) end

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

                dest = WebUtil.JspURL+"D/D04VocationDetail_m_print.jsp?jobid_m=search";
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}